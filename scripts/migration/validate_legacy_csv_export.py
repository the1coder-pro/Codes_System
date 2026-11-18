#!/usr/bin/env python3
"""Validate a table-per-CSV export against the reconstructed SQLite schema.

The validator streams archive contents into a temporary database, reports only
schema/count/length diagnostics, and deletes the temporary database on exit.
It never prints or stores record values.
"""

from __future__ import annotations

import argparse
import csv
import io
import sqlite3
import sys
import tempfile
import zipfile
from collections import Counter
from datetime import datetime
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_SCHEMA = (
    ROOT / "artifacts/accounting/flutter_app/migration/legacy_schema.sqlite.sql"
)


def quote_identifier(name: str) -> str:
    if not name or any(ord(character) < 32 for character in name):
        raise ValueError("Unsupported SQL identifier")
    return '"' + name.replace('"', '""') + '"'


def safe_csv_entries(archive: zipfile.ZipFile) -> list[zipfile.ZipInfo]:
    entries = []
    for info in archive.infolist():
        path = PurePosixPath(info.filename)
        if path.is_absolute() or ".." in path.parts or "\\" in info.filename:
            raise ValueError("The archive contains an unsafe file path")
        if (
            info.filename.lower().endswith(".csv")
            and not info.filename.startswith("__MACOSX/")
        ):
            entries.append(info)
    return entries


def open_csv_text(archive: zipfile.ZipFile, info: zipfile.ZipInfo):
    raw = archive.open(info)
    sample = raw.read(8192)
    raw.seek(0)
    try:
        sample.decode("utf-8-sig")
        encoding = "utf-8-sig"
    except UnicodeDecodeError:
        encoding = "cp1256"
    return io.TextIOWrapper(raw, encoding=encoding, errors="strict", newline="")


def is_valid_datetime(value: str) -> bool:
    value = value.strip()
    if not value:
        return True
    normalized = value.replace("Z", "+00:00")
    try:
        datetime.fromisoformat(normalized)
        return True
    except ValueError:
        pass
    for pattern in (
        "%m/%d/%Y",
        "%m/%d/%Y %H:%M:%S",
        "%m/%d/%Y %I:%M:%S %p",
        "%d/%m/%Y",
        "%d/%m/%Y %H:%M:%S",
        "%d/%m/%Y %I:%M:%S %p",
    ):
        try:
            datetime.strptime(value, pattern)
            return True
        except ValueError:
            continue
    return False


def validate_export(
    archive_path: Path, schema_path: Path, *, empty_as_null: bool = False
) -> tuple[int, int, list[str]]:
    failures: list[str] = []
    total_rows = 0
    table_count = 0
    with zipfile.ZipFile(archive_path) as archive:
        entries = safe_csv_entries(archive)
        entry_by_table: dict[str, zipfile.ZipInfo] = {}
        for info in entries:
            table_name = PurePosixPath(info.filename).stem
            if table_name in entry_by_table:
                raise ValueError(f"Duplicate CSV export for table {table_name}")
            entry_by_table[table_name] = info

        with tempfile.TemporaryDirectory(prefix="legacy-csv-validation-") as temp:
            database = sqlite3.connect(Path(temp) / "validation.sqlite")
            try:
                database.executescript(schema_path.read_text(encoding="utf-8"))
                table_names = {
                    row[0]
                    for row in database.execute(
                        "SELECT name FROM sqlite_master WHERE type = 'table'"
                    )
                }
                missing = sorted(table_names - entry_by_table.keys())
                extra = sorted(entry_by_table.keys() - table_names)
                if missing:
                    failures.append(f"{len(missing)} schema tables have no CSV")
                if extra:
                    failures.append(f"{len(extra)} CSV files are not schema tables")

                for table_name in sorted(table_names & entry_by_table.keys()):
                    info = entry_by_table[table_name]
                    quoted_table = quote_identifier(table_name)
                    columns = [
                        row[1]
                        for row in database.execute(
                            f"PRAGMA table_info({quoted_table})"
                        )
                    ]
                    column_types = {
                        row[1]: (row[2] or "").upper()
                        for row in database.execute(
                            f"PRAGMA table_info({quoted_table})"
                        )
                    }
                    indexed_columns = {
                        column
                        for index_row in database.execute(
                            f"PRAGMA index_list({quoted_table})"
                        )
                        for index_info in database.execute(
                            f"PRAGMA index_info({quote_identifier(index_row[1])})"
                        )
                        if (column := index_info[2]) is not None
                    }

                    text = open_csv_text(archive, info)
                    reader = csv.reader(text)
                    try:
                        header = next(reader)
                    except StopIteration:
                        failures.append(f"{table_name}: empty CSV")
                        continue
                    if header != columns:
                        failures.append(f"{table_name}: CSV header differs from schema")
                        continue
                    table_count += 1

                    placeholders = ", ".join("?" for _ in columns)
                    column_list = ", ".join(quote_identifier(name) for name in columns)
                    insert = (
                        f"INSERT INTO {quoted_table} ({column_list}) "
                        f"VALUES ({placeholders})"
                    )
                    batch: list[list[str]] = []
                    row_count = 0
                    bad_width = False
                    too_long_varchar: set[str] = set()
                    too_long_indexed_text: set[str] = set()
                    invalid_datetimes: Counter[str] = Counter()
                    try:
                        with database:
                            for row in reader:
                                row_count += 1
                                if len(row) != len(columns):
                                    bad_width = True
                                    continue
                                for name, value in zip(columns, row):
                                    size = len(value)
                                    if column_types[name] == "VARCHAR" and size > 255:
                                        too_long_varchar.add(name)
                                    if (
                                        column_types[name] == "DATETIME"
                                        and value
                                        and not is_valid_datetime(value)
                                    ):
                                        invalid_datetimes[name] += 1
                                    if (
                                        column_types[name] == "TEXT"
                                        and name in indexed_columns
                                        and size > 450
                                    ):
                                        too_long_indexed_text.add(name)
                                batch.append(
                                    [
                                        None if empty_as_null and value == "" else value
                                        for value in row
                                    ]
                                )
                                if len(batch) == 1000:
                                    database.executemany(insert, batch)
                                    batch.clear()
                            if batch:
                                database.executemany(insert, batch)
                    except sqlite3.IntegrityError as error:
                        failures.append(
                            f"{table_name}: SQL constraint validation failed "
                            f"({error})"
                        )
                        total_rows += row_count
                        continue
                    except (csv.Error, UnicodeDecodeError, OSError) as error:
                        failures.append(
                            f"{table_name}: CSV parsing failed ({type(error).__name__})"
                        )
                        total_rows += row_count
                        continue
                    finally:
                        text.close()

                    if bad_width:
                        failures.append(f"{table_name}: rows have incorrect field counts")
                    if too_long_varchar:
                        failures.append(
                            f"{table_name}: VARCHAR fields exceed 255 characters: "
                            + ", ".join(sorted(too_long_varchar))
                        )
                    if too_long_indexed_text:
                        failures.append(
                            f"{table_name}: indexed TEXT fields exceed 450 characters: "
                            + ", ".join(sorted(too_long_indexed_text))
                        )
                    if invalid_datetimes:
                        failures.append(
                            f"{table_name}: invalid DateTime values "
                            + ", ".join(
                                f"{name} ({count} rows)"
                                for name, count in sorted(invalid_datetimes.items())
                            )
                        )

                    stored_count = database.execute(
                        f"SELECT COUNT(*) FROM {quoted_table}"
                    ).fetchone()[0]
                    if stored_count != row_count:
                        failures.append(f"{table_name}: stored row count differs")
                    total_rows += row_count
            finally:
                database.close()

    return table_count, total_rows, failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--archive", type=Path, required=True)
    parser.add_argument("--schema", type=Path, default=DEFAULT_SCHEMA)
    parser.add_argument(
        "--empty-as-null",
        action="store_true",
        help=(
            "For constraint testing only, interpret every empty CSV field as "
            "SQL NULL. This can lose real zero-length strings."
        ),
    )
    args = parser.parse_args()
    try:
        table_count, total_rows, failures = validate_export(
            args.archive, args.schema, empty_as_null=args.empty_as_null
        )
    except (OSError, ValueError, zipfile.BadZipFile, sqlite3.Error) as error:
        print(f"Validation could not run: {type(error).__name__}", file=sys.stderr)
        return 2
    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        print(
            f"CSV export checks found issues: {table_count} tables, "
            f"{total_rows} rows."
        )
        return 1
    mode = " (empty fields mapped to NULL for this test)" if args.empty_as_null else ""
    print(
        f"CSV export validated{mode}: {table_count} tables, {total_rows} rows."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
