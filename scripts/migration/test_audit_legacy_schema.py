import unittest
from pathlib import Path

from audit_legacy_schema import (
    parse_schema,
    render_sql,
    render_sqlserver_sql,
    validate_sql,
)


class LegacySchemaAuditTests(unittest.TestCase):
    def test_keeps_joined_and_separated_legacy_names(self):
        source = """\
CREATE TABLE tblSample
 (
ItemIDINTEGER,
NameText TEXT,
RateREAL NOT NULL
, PRIMARY KEY (ItemID)
);

CREATE UNIQUE INDEX tblSample_ItemID_idx ON tblSample (ItemID);
"""
        tables, indexes = parse_schema(source)

        self.assertEqual(
            [column.name for column in tables[0].columns],
            ["ItemID", "NameText", "Rate"],
        )
        self.assertEqual([column.declared_type for column in tables[0].columns],
                         ["INTEGER", "TEXT", "REAL"])
        self.assertEqual(tables[0].primary_key, ("ItemID",))
        self.assertEqual(indexes[0].name, "tblSample_ItemID_idx")
        validate_sql(render_sql(tables, indexes), tables, indexes)
        sqlserver_sql = render_sqlserver_sql(tables, indexes)
        self.assertIn("[tblSample]", sqlserver_sql)
        self.assertIn("[ItemID] INT", sqlserver_sql)

    def test_full_export_retains_schema_objects(self):
        root = Path(__file__).resolve().parents[2]
        source_path = (
            root
            / "artifacts/accounting/flutter_app/migration/source_access_schema.sql"
        )
        tables, indexes = parse_schema(source_path.read_text(encoding="utf-8"))

        self.assertEqual(len(tables), 357)
        self.assertEqual(sum(len(table.columns) for table in tables), 2135)
        self.assertEqual(len(indexes), 982)
        absence_day = next(table for table in tables if table.name == "tblAbsenceDay")
        self.assertIn("AccountID", [column.name for column in absence_day.columns])
        self.assertIn("tblAbsenceDay_AbsenceNo_idx", {index.name for index in indexes})
        sqlite_sql = render_sql(tables, indexes)
        validate_sql(sqlite_sql, tables, indexes)
        sqlserver_sql = render_sqlserver_sql(tables, indexes)
        self.assertEqual(sqlserver_sql.count("CREATE TABLE "), 357)
        self.assertEqual(sqlserver_sql.count("INDEX ["), 982)
        self.assertIn("[tblAbsenceDay]", sqlserver_sql)
        self.assertIn("[AccountID] INT", sqlserver_sql)
        self.assertIn(
            "[tblContractInstalllmentMoneyTransaction_tblContractInstalllmentID_idx]",
            sqlserver_sql,
        )
        self.assertIn("[NumbersList] NVARCHAR(450)", sqlserver_sql)
        for table in tables:
            self.assertIn(f"[{table.name}]", sqlserver_sql)
            for column in table.columns:
                self.assertIn(f"[{column.name}]", sqlserver_sql)
        for index in indexes:
            self.assertIn(f"[{index.name}]", sqlserver_sql)

        migration_dir = source_path.parent
        self.assertEqual(
            (migration_dir / "legacy_schema.sqlite.sql").read_text(
                encoding="utf-8"
            ),
            sqlite_sql,
        )
        self.assertEqual(
            (migration_dir / "legacy_schema.sqlserver.candidate.sql").read_text(
                encoding="utf-8"
            ),
            sqlserver_sql,
        )


if __name__ == "__main__":
    unittest.main()
