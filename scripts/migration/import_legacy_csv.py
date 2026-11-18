#!/usr/bin/env python3
"""Import a verified local Access CSV export into the exact legacy SQLite schema.

The importer writes only to a new database file. It preserves text, NULL, empty
strings, binary data, and invalid legacy date text; it never prints record data.
"""

from __future__ import annotations

import argparse
import base64
import binascii
import csv
import json
import os
import sqlite3
import sys
import tempfile
import zipfile
from collections import Counter
from pathlib import Path, PurePosixPath

from validate_legacy_csv_export import (
    DEFAULT_SCHEMA,
    is_valid_datetime,
    open_csv_text,
    quote_identifier,
    safe_csv_entries,
)

NULL_MARKER = r"\N"
ESCAPE_PREFIX = "\\"
ESCAPE_RULE = "Text values beginning with backslash have one extra leading backslash."
EXPORT_FORMAT_VERSION = 1


def read_export_metadata(archive: zipfile.ZipFile, expected_table_count: int) -> dict:
    try:
        encoded = archive.read("_export_manifest.json")
        metadata = json.loads(encoded.decode("utf-8"))
    except KeyError as error:
        raise ValueError("The archive has no Access export manifest.") from error
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise ValueError("The Access export manifest is invalid.") from error

    if (
        not isinstance(metadata, dict)
        or metadata.get("formatVersion") != EXPORT_FORMAT_VERSION
        or metadata.get("tableCount") != expected_table_count
        or metadata.get("nullMarker") != NULL_MARKER
        or metadata.get("escapeRule") != ESCAPE_RULE
        or metadata.get("binaryFormat") != "base64:"
        or not isinstance(metadata.get("rowCounts"), dict)
    ):
        raise ValueError("The Access export manifest is incompatible.")
    return metadata


def decode_cell(
    value: str, column_type: str, *, null_marker: str, escape_prefix: str
) -> object:
    if value == null_marker:
        return None
    if value.startswith(escape_prefix * 2):
        value = value[len(escape_prefix) :]
    if column_type == "BLOB":
        if not value.startswith("base64:"):
            raise ValueError("A binary field does not use the expected base64 format.")
        try:
            return base64.b64decode(value[len("base64:") :], validate=True)
        except (ValueError, binascii.Error) as error:
            raise ValueError("A binary field contains invalid base64.") from error
    return value


def import_export(
    archive_path: Path,
    output_path: Path,
    schema_path: Path = DEFAULT_SCHEMA,
) -> tuple[int, dict[str, int], dict[str, int]]:
    output_path = output_path.resolve()
    if output_path.exists():
        raise FileExistsError("Output database already exists; choose another path.")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    temporary_path: Path | None = None
    succeeded = False
    imported_rows: dict[str, int] = {}
    invalid_dates: Counter[str] = Counter()

    try:
        with zipfile.ZipFile(archive_path) as archive:
            csv_entries = safe_csv_entries(archive)
            entry_by_table: dict[str, zipfile.ZipInfo] = {}
            for info in csv_entries:
                table_name = PurePosixPath(info.filename).stem
                if table_name in entry_by_table:
                    raise ValueError(f"Duplicate CSV export for table {table_name}.")
                entry_by_table[table_name] = info

            with tempfile.NamedTemporaryFile(
                prefix=f".{output_path.name}.",
                suffix=".partial",
                dir=output_path.parent,
                delete=False,
            ) as temporary:
                temporary_path = Path(temporary.name)

            database = sqlite3.connect(temporary_path)
            try:
                database.execute("PRAGMA foreign_keys = ON")
                database.executescript(schema_path.read_text(encoding="utf-8"))
                table_names = {
                    row[0]
                    for row in database.execute(
                        "SELECT name FROM sqlite_master WHERE type='table'"
                    )
                }
                if set(entry_by_table) != table_names:
                    missing_count = len(table_names - entry_by_table.keys())
                    extra_count = len(entry_by_table.keys() - table_names)
                    raise ValueError(
                        f"CSV table set differs from the legacy schema "
                        f"({missing_count} missing, {extra_count} unexpected)."
                    )
                metadata = read_export_metadata(archive, len(table_names))
                declared_counts = metadata["rowCounts"]
                if set(declared_counts) != table_names:
                    raise ValueError("Export manifest table counts do not match the schema.")

                for table_name in sorted(table_names):
                    info = entry_by_table[table_name]
                    quoted_table = quote_identifier(table_name)
                    schema_columns = list(
                        database.execute(
                            f"PRAGMA table_info({quoted_table})"
                        )
                    )
                    columns = [row[1] for row in schema_columns]
                    column_types = {
                        row[1]: (row[2] or "").upper()
                        for row in schema_columns
                    }

                    text = open_csv_text(archive, info)
                    reader = csv.reader(text)
                    try:
                        header = next(reader)
                    except StopIteration as error:
                        text.close()
                        raise ValueError(f"{table_name}: CSV is empty.") from error
                    if header != columns:
                        text.close()
                        raise ValueError(
                            f"{table_name}: CSV headers differ from the exact legacy schema."
                        )

                    placeholders = ", ".join("?" for _ in columns)
                    column_list = ", ".join(quote_identifier(name) for name in columns)
                    insert = (
                        f"INSERT INTO {quoted_table} ({column_list}) "
                        f"VALUES ({placeholders})"
                    )
                    batch: list[tuple[object, ...]] = []
                    row_count = 0
                    try:
                        with database:
                            for row in reader:
                                row_count += 1
                                if len(row) != len(columns):
                                    raise ValueError(
                                        f"{table_name}: a row has an incorrect field count."
                                    )
                                values: list[object] = []
                                for name, value in zip(columns, row):
                                    if (
                                        column_types[name] == "DATETIME"
                                        and value not in ("", NULL_MARKER)
                                        and not is_valid_datetime(value)
                                    ):
                                        invalid_dates[name] += 1
                                    values.append(
                                        decode_cell(
                                            value,
                                            column_types[name],
                                            null_marker=NULL_MARKER,
                                            escape_prefix=ESCAPE_PREFIX,
                                        )
                                    )
                                batch.append(tuple(values))
                                if len(batch) >= 1000:
                                    database.executemany(insert, batch)
                                    batch.clear()
                            if batch:
                                database.executemany(insert, batch)
                    except sqlite3.IntegrityError as error:
                        raise ValueError(
                            f"{table_name}: SQLite constraint check failed ({error})."
                        ) from None
                    except (csv.Error, UnicodeDecodeError) as error:
                        raise ValueError(
                            f"{table_name}: CSV parsing failed ({type(error).__name__})."
                        ) from None
                    finally:
                        text.close()

                    if declared_counts[table_name] != row_count:
                        raise ValueError(
                            f"{table_name}: row count differs from the export manifest."
                        )
                    imported_rows[table_name] = row_count
                    stored_count = database.execute(
                        f"SELECT COUNT(*) FROM {quoted_table}"
                    ).fetchone()[0]
                    if stored_count != row_count:
                        raise ValueError(f"{table_name}: imported row count differs.")

                check = database.execute("PRAGMA quick_check").fetchone()
                if check is None or check[0] != "ok":
                    raise ValueError("SQLite reported an integrity problem.")
            finally:
                database.close()

        # Hard-linking within the same directory atomically refuses to replace
        # an existing output file on both macOS and Linux.
        os.link(temporary_path, output_path)
        temporary_path.unlink()
        succeeded = True
    finally:
        if not succeeded and temporary_path is not None:
            temporary_path.unlink(missing_ok=True)

    return sum(imported_rows.values()), imported_rows, dict(invalid_dates)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--archive", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--schema", type=Path, default=DEFAULT_SCHEMA)
    args = parser.parse_args()

    try:
        total, row_counts, invalid_dates = import_export(
            args.archive, args.output, args.schema
        )
    except (OSError, ValueError, zipfile.BadZipFile, sqlite3.Error) as error:
        print(
            f"Import stopped: {type(error).__name__}: {error}",
            file=sys.stderr,
        )
        return 1

    print(
        f"Imported {len(row_counts)} legacy tables and {total} rows "
        f"to {args.output}."
    )
    if invalid_dates:
        summary = ", ".join(
            f"{name} ({count} rows)" for name, count in sorted(invalid_dates.items())
        )
        print(
            "Warning: preserved invalid legacy date text verbatim for SQLite: "
            + summary
        )
        print(
            "These values need a separate SQL Server storage/conversion decision; "
            "they were not changed."
        )
    print("No record values were printed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
