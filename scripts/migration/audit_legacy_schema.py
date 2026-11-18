#!/usr/bin/env python3
"""Validate and normalize the legacy MDB Tools SQL export without renaming it.

This tool repairs the missing separator between a column identifier and its
declared type in the supplied schema export. It keeps table, column, index,
and key names as written, then asks SQLite itself to validate the result.
It never reads or writes business records.
"""

from __future__ import annotations

import argparse
import json
import re
import sqlite3
from dataclasses import asdict, dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INPUT = (
    ROOT / "artifacts/accounting/flutter_app/migration/source_access_schema.sql"
)
DEFAULT_OUTPUT = (
    ROOT / "artifacts/accounting/flutter_app/migration/legacy_schema.sqlite.sql"
)
DEFAULT_SQLSERVER_OUTPUT = (
    ROOT
    / "artifacts/accounting/flutter_app/migration/legacy_schema.sqlserver.candidate.sql"
)
DEFAULT_MANIFEST = (
    ROOT / "artifacts/accounting/flutter_app/migration/legacy_schema_manifest.json"
)
TYPE_NAMES = ("DATETIME", "INTEGER", "VARCHAR", "BLOB", "TEXT", "REAL")
TYPE_PATTERN = "|".join(TYPE_NAMES)
SEPARATED_COLUMN = re.compile(
    rf"^(?P<name>\S+)\s+(?P<type>{TYPE_PATTERN})\b(?P<tail>.*)$",
    re.IGNORECASE,
)
JOINED_COLUMN = re.compile(
    rf"^(?P<name>.+)(?P<type>{TYPE_PATTERN})(?P<tail>\s+.*)?$",
    re.IGNORECASE,
)
TABLE_PATTERN = re.compile(
    r"CREATE\s+TABLE\s+(?P<name>[^\s(]+)\s*\((?P<body>.*?)\n\);",
    re.IGNORECASE | re.DOTALL,
)
INDEX_PATTERN = re.compile(
    r"CREATE\s+(?P<unique>UNIQUE\s+)?INDEX\s+"
    r"(?P<name>[^\s]+)\s+ON\s+(?P<table>[^\s(]+)\s*"
    r"\((?P<columns>[^)]*)\)\s*;",
    re.IGNORECASE,
)
PRIMARY_KEY_PATTERN = re.compile(
    r"^,?\s*PRIMARY\s+KEY\s*\((?P<columns>[^)]*)\)\s*$",
    re.IGNORECASE,
)
@dataclass(frozen=True)
class Column:
    name: str
    declared_type: str
    constraints: str
    source_declaration: str


@dataclass(frozen=True)
class Table:
    name: str
    columns: tuple[Column, ...]
    primary_key: tuple[str, ...]


@dataclass(frozen=True)
class Index:
    name: str
    table: str
    columns: tuple[str, ...]
    unique: bool


def quote_identifier(identifier: str) -> str:
    if not identifier or any(ord(character) < 32 for character in identifier):
        raise ValueError(f"Unsupported identifier syntax: {identifier!r}")
    return '"' + identifier.replace('"', '""') + '"'


def quote_sqlserver_identifier(identifier: str) -> str:
    if not identifier or any(ord(character) < 32 for character in identifier):
        raise ValueError(f"Unsupported identifier syntax: {identifier!r}")
    return "[" + identifier.replace("]", "]]") + "]"


def split_column_declaration(line: str, table_name: str) -> Column:
    declaration = line.strip().rstrip(",").strip()
    match = SEPARATED_COLUMN.fullmatch(declaration)
    if match is None:
        match = JOINED_COLUMN.fullmatch(declaration)
    if match is None:
        raise ValueError(
            f"Could not identify the column name and type in "
            f"{table_name}: {declaration!r}"
        )

    name = match.group("name").strip()
    declared_type = match.group("type")
    constraints = (match.group("tail") or "").strip()
    quote_identifier(name)
    if constraints and not re.fullmatch(
        r"(?:(?:NOT\s+NULL|NULL|UNIQUE|PRIMARY\s+KEY|"
        r"DEFAULT\s+(?:NULL|[-+]?\d+(?:\.\d+)?|'(?:''|[^'])*'))"
        r"(?:\s+|$))*",
        constraints,
        re.IGNORECASE,
    ):
        raise ValueError(
            f"Unreviewed column constraint in {table_name}.{name}: "
            f"{constraints!r}"
        )
    return Column(
        name=name,
        declared_type=declared_type,
        constraints=constraints,
        source_declaration=declaration,
    )


def parse_schema(text: str) -> tuple[list[Table], list[Index]]:
    tables: list[Table] = []
    for match in TABLE_PATTERN.finditer(text):
        table_name = match.group("name")
        quote_identifier(table_name)
        columns: list[Column] = []
        primary_key: tuple[str, ...] = ()
        for raw_line in match.group("body").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("--"):
                continue
            primary_match = PRIMARY_KEY_PATTERN.fullmatch(line.rstrip(","))
            if primary_match:
                primary_key = tuple(
                    value.strip()
                    for value in primary_match.group("columns").split(",")
                )
                for name in primary_key:
                    quote_identifier(name)
                continue
            columns.append(split_column_declaration(line, table_name))
        if not columns:
            raise ValueError(f"Table has no parsed columns: {table_name}")
        tables.append(Table(table_name, tuple(columns), primary_key))

    indexes: list[Index] = []
    for match in INDEX_PATTERN.finditer(text):
        name = match.group("name")
        table_name = match.group("table")
        columns = tuple(value.strip() for value in match.group("columns").split(","))
        quote_identifier(name)
        quote_identifier(table_name)
        for column in columns:
            quote_identifier(column)
        indexes.append(
            Index(name, table_name, columns, bool(match.group("unique")))
        )

    if not tables:
        raise ValueError("No CREATE TABLE statements were found.")
    if not indexes:
        raise ValueError("No CREATE INDEX statements were found.")
    return tables, indexes


def render_sql(tables: list[Table], indexes: list[Index]) -> str:
    statements = [
        "-- Exact-name SQLite schema reconstructed from the legacy MDB Tools export.",
        "-- Only missing name/type separators are repaired; no business data is changed.",
        "PRAGMA foreign_keys = ON;",
        "",
    ]
    for table in tables:
        definitions = [
            "  "
            + quote_identifier(column.name)
            + " "
            + column.declared_type
            + (f" {column.constraints}" if column.constraints else "")
            for column in table.columns
        ]
        if table.primary_key:
            definitions.append(
                "  PRIMARY KEY ("
                + ", ".join(quote_identifier(name) for name in table.primary_key)
                + ")"
            )
        statements.append(
            f"CREATE TABLE {quote_identifier(table.name)} (\n"
            + ",\n".join(definitions)
            + "\n);"
        )
        statements.append("")

    for index in indexes:
        unique = "UNIQUE " if index.unique else ""
        columns = ", ".join(quote_identifier(name) for name in index.columns)
        statements.append(
            f"CREATE {unique}INDEX {quote_identifier(index.name)} "
            f"ON {quote_identifier(index.table)} ({columns});"
        )
    return "\n".join(statements) + "\n"


def render_sqlserver_sql(tables: list[Table], indexes: list[Index]) -> str:
    type_mapping = {
        "INTEGER": "INT",
        "REAL": "FLOAT(53)",
        "DATETIME": "DATETIME2",
        "BLOB": "VARBINARY(MAX)",
    }
    indexed_columns = {
        (index.table, column) for index in indexes for column in index.columns
    }
    statements = [
        "-- SQL Server schema candidate from the exact-name legacy manifest.",
        "-- Review type and index behavior against a real target before deployment.",
        "-- Unicode text and wide numeric/date types avoid lossy value conversion.",
        "",
    ]
    for table in tables:
        definitions = []
        for column in table.columns:
            source_type = column.declared_type.upper()
            if source_type == "VARCHAR":
                sql_type = "NVARCHAR(255)"
            elif source_type == "TEXT":
                sql_type = (
                    "NVARCHAR(450)"
                    if (table.name, column.name) in indexed_columns
                    else "NVARCHAR(MAX)"
                )
            else:
                sql_type = type_mapping[source_type]
            definitions.append(
                "  "
                + quote_sqlserver_identifier(column.name)
                + " "
                + sql_type
                + (f" {column.constraints}" if column.constraints else "")
            )
        if table.primary_key:
            definitions.append(
                "  PRIMARY KEY ("
                + ", ".join(
                    quote_sqlserver_identifier(name) for name in table.primary_key
                )
                + ")"
            )
        statements.append(
            f"CREATE TABLE {quote_sqlserver_identifier(table.name)} (\n"
            + ",\n".join(definitions)
            + "\n);"
        )
        statements.append("")

    for index in indexes:
        unique = "UNIQUE " if index.unique else ""
        columns = ", ".join(
            quote_sqlserver_identifier(name) for name in index.columns
        )
        statements.append(
            f"CREATE {unique}INDEX {quote_sqlserver_identifier(index.name)} "
            f"ON {quote_sqlserver_identifier(index.table)} ({columns});"
        )
    return "\n".join(statements) + "\n"


def validate_sql(sql: str, tables: list[Table], indexes: list[Index]) -> None:
    database = sqlite3.connect(":memory:")
    try:
        database.executescript(sql)
        actual_tables = {
            row[0]
            for row in database.execute(
                "SELECT name FROM sqlite_master WHERE type = 'table' "
                "AND name NOT LIKE 'sqlite_%'"
            )
        }
        expected_tables = {table.name for table in tables}
        if actual_tables != expected_tables:
            raise ValueError(
                f"SQLite table mismatch: expected {len(expected_tables)}, "
                f"got {len(actual_tables)}"
            )

        for table in tables:
            actual_columns = [
                row[1]
                for row in database.execute(
                    f"PRAGMA table_info({quote_identifier(table.name)})"
                )
            ]
            expected_columns = [column.name for column in table.columns]
            if actual_columns != expected_columns:
                raise ValueError(
                    f"Column name/order mismatch in {table.name}: "
                    f"{actual_columns!r} != {expected_columns!r}"
                )
            actual_primary_key = [
                row[1]
                for row in sorted(
                    database.execute(
                        f"PRAGMA table_info({quote_identifier(table.name)})"
                    ),
                    key=lambda row: row[5],
                )
                if row[5]
            ]
            if actual_primary_key != list(table.primary_key):
                raise ValueError(
                    f"Primary-key mismatch in {table.name}: "
                    f"{actual_primary_key!r} != {list(table.primary_key)!r}"
                )

        actual_indexes = {
            row[0]
            for row in database.execute(
                "SELECT name FROM sqlite_master WHERE type = 'index' "
                "AND name NOT LIKE 'sqlite_%'"
            )
        }
        expected_indexes = {index.name for index in indexes}
        if actual_indexes != expected_indexes:
            raise ValueError(
                f"SQLite index mismatch: expected {len(expected_indexes)}, "
                f"got {len(actual_indexes)}"
            )
        for index in indexes:
            actual_columns = [
                row[2]
                for row in database.execute(
                    f"PRAGMA index_info({quote_identifier(index.name)})"
                )
            ]
            if actual_columns != list(index.columns):
                raise ValueError(
                    f"Index column mismatch in {index.name}: "
                    f"{actual_columns!r} != {list(index.columns)!r}"
                )
    finally:
        database.close()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--sqlserver-output", type=Path, default=DEFAULT_SQLSERVER_OUTPUT)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    args = parser.parse_args()

    source = args.input.read_text(encoding="utf-8")
    tables, indexes = parse_schema(source)
    sql = render_sql(tables, indexes)
    sqlserver_sql = render_sqlserver_sql(tables, indexes)
    validate_sql(sql, tables, indexes)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(sql, encoding="utf-8")
    args.sqlserver_output.parent.mkdir(parents=True, exist_ok=True)
    args.sqlserver_output.write_text(sqlserver_sql, encoding="utf-8")
    identifiers = [
        table.name for table in tables
    ] + [
        column.name for table in tables for column in table.columns
    ] + [index.name for index in indexes]
    sqlserver_long_identifiers = [
        name for name in identifiers if len(name) > 128
    ]
    manifest = {
        "source": args.input.name,
        "tableCount": len(tables),
        "columnCount": sum(len(table.columns) for table in tables),
        "indexCount": len(indexes),
        "foreignKeyCount": len(
            re.findall(r"\bFOREIGN\s+KEY\b", source, re.IGNORECASE)
        ),
        "sqlServerIdentifierLimitCharacters": 128,
        "sqlServerLongIdentifiers": sqlserver_long_identifiers,
        "tables": [asdict(table) for table in tables],
        "indexes": [asdict(index) for index in indexes],
    }
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        f"Validated {len(tables)} tables, "
        f"{sum(len(table.columns) for table in tables)} columns, "
        f"and {len(indexes)} indexes in SQLite; rendered SQL Server candidate."
    )
    if sqlserver_long_identifiers:
        raise ValueError(
            "SQL Server's 128-character limit cannot preserve these identifiers: "
            + ", ".join(sqlserver_long_identifiers)
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
