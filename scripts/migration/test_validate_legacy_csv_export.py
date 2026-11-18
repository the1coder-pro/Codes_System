import tempfile
import unittest
import zipfile
from pathlib import Path

from validate_legacy_csv_export import validate_export


class LegacyCsvExportTests(unittest.TestCase):
    def validate_sample(
        self,
        rows,
        *,
        empty_as_null=False,
        schema_sql=(
            'CREATE TABLE "tblSample" ('
            '"ID" INTEGER NOT NULL, "Name" VARCHAR);'
            'CREATE UNIQUE INDEX "tblSample_Name_idx" '
            'ON "tblSample" ("Name");'
        ),
        header="ID,Name\n",
        null_marker=None,
        escape_prefix=None,
    ):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            schema_path = root / "schema.sql"
            schema_path.write_text(schema_sql, encoding="utf-8")
            archive_path = root / "tables.zip"
            with zipfile.ZipFile(archive_path, "w") as archive:
                archive.writestr("tblSample.csv", header + rows)
            return validate_export(
                archive_path,
                schema_path,
                empty_as_null=empty_as_null,
                null_marker=null_marker,
                escape_prefix=escape_prefix,
            )

    def test_accepts_exact_headers_and_unique_rows(self):
        tables, rows, failures = self.validate_sample("1,one\n2,two\n")
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(failures, [])

    def test_reports_unique_constraint_conflict_without_record_values(self):
        tables, rows, failures = self.validate_sample("1,same\n2,same\n")
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(len(failures), 1)
        self.assertIn("tblSample.Name", failures[0])
        self.assertNotIn("same", failures[0])

    def test_empty_as_null_is_only_an_explicit_constraint_test_mode(self):
        tables, rows, failures = self.validate_sample(
            "1,\n2,\n", empty_as_null=True
        )
        self.assertEqual((tables, rows), (1, 2))
        self.assertEqual(failures, [])

    def test_explicit_null_marker_keeps_empty_string_and_escaped_text_distinct(self):
        tables, rows, failures = self.validate_sample(
            "1,\\N\n2,\\\\N\n3,\n",
            null_marker="\\N",
            escape_prefix="\\",
        )
        self.assertEqual((tables, rows), (1, 3))
        self.assertEqual(failures, [])

    def test_explicit_null_marker_can_decode_blob_base64(self):
        tables, rows, failures = self.validate_sample(
            "1,base64:AQI=\n",
            schema_sql=(
                'CREATE TABLE "tblSample" ('
                '"ID" INTEGER NOT NULL, "Data" BLOB);'
            ),
            header="ID,Data\n",
        )
        self.assertEqual((tables, rows), (1, 1))
        self.assertEqual(failures, [])

    def test_null_marker_cannot_be_combined_with_empty_as_null(self):
        with self.assertRaises(ValueError):
            self.validate_sample(
                "1,\n",
                empty_as_null=True,
                null_marker="\\N",
            )

    def test_reports_invalid_datetime_without_echoing_record_data(self):
        tables, rows, failures = self.validate_sample(
            "2020-05-00 00:00:00\n",
            schema_sql='CREATE TABLE "tblSample" ("Date" DATETIME);',
            header="Date\n",
        )
        self.assertEqual((tables, rows), (1, 1))
        self.assertEqual(len(failures), 1)
        self.assertIn("Date (1 rows)", failures[0])
        self.assertNotIn("2020", failures[0])


if __name__ == "__main__":
    unittest.main()
