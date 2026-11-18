import tempfile
import unittest
import zipfile
from pathlib import Path

from validate_legacy_csv_export import validate_export


class LegacyCsvExportTests(unittest.TestCase):
    def validate_sample(self, rows):
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
            return validate_export(archive_path, schema_path)

    def test_accepts_exact_headers_and_unique_rows(self):
        tables, rows, failures = self.validate_sample("1,one\n2,two\n")
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(failures, [])

    def test_reports_unique_constraint_conflict_without_record_values(self):
        tables, rows, failures = self.validate_sample("1,same\n2,same\n")
        self.assertEqual((tables, rows), (0, 0))
        self.assertEqual(len(failures), 1)
        self.assertIn("tblSample_Name_idx", failures[0])
        self.assertNotIn("same", failures[0])


if __name__ == "__main__":
    unittest.main()
