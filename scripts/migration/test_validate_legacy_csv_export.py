import tempfile
import unittest
import zipfile
from pathlib import Path

from validate_legacy_csv_export import validate_export


class LegacyCsvExportTests(unittest.TestCase):
    def validate_sample(self, rows, *, empty_as_null=False):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            schema_path = root / "schema.sql"
            schema_path.write_text(
                'CREATE TABLE "tblSample" ('
                '"ID" INTEGER NOT NULL, "Name" VARCHAR);'
                'CREATE UNIQUE INDEX "tblSample_Name_idx" '
                'ON "tblSample" ("Name");',
                encoding="utf-8",
            )
            archive_path = root / "tables.zip"
            with zipfile.ZipFile(archive_path, "w") as archive:
                archive.writestr("tblSample.csv", "ID,Name\n" + rows)
            return validate_export(
                archive_path, schema_path, empty_as_null=empty_as_null
            )

    def test_accepts_exact_headers_and_unique_rows(self):
        tables, rows, failures = self.validate_sample("1,one\n2,two\n")
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(failures, [])

    def test_reports_unique_constraint_conflict_without_record_values(self):
        tables, rows, failures = self.validate_sample("1,same\n2,same\n")
        self.assertEqual((tables, rows), (0, 0))
        self.assertEqual(len(failures), 1)
        self.assertIn("tblSample.Name", failures[0])
        self.assertNotIn("same", failures[0])

    def test_empty_as_null_is_only_an_explicit_constraint_test_mode(self):
        tables, rows, failures = self.validate_sample(
            "1,\n2,\n", empty_as_null=True
        )
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(failures, [])


if __name__ == "__main__":
    unittest.main()
