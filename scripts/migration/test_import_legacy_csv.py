import csv
import io
import json
import sqlite3
import tempfile
import unittest
import zipfile
from pathlib import Path

from import_legacy_csv import import_export


SCHEMA = (
    'CREATE TABLE "tblSample" ('
    '"ID" INTEGER NOT NULL, "Name" VARCHAR, '
    '"EventDate" DATETIME, "Payload" BLOB);'
    'CREATE UNIQUE INDEX "tblSample_Name_idx" '
    'ON "tblSample" ("Name");'
)


class LegacySqliteImportTests(unittest.TestCase):
    def make_archive(self, root, rows):
        archive_path = root / "export.zip"
        output = io.StringIO()
        writer = csv.writer(output, lineterminator="\n")
        writer.writerow(["ID", "Name", "EventDate", "Payload"])
        writer.writerows(rows)
        metadata = {
            "formatVersion": 1,
            "tableCount": 1,
            "nullMarker": r"\N",
            "escapeRule": (
                "Text values beginning with backslash have one extra leading backslash."
            ),
            "binaryFormat": "base64:",
            "rowCounts": {"tblSample": len(rows)},
        }
        with zipfile.ZipFile(archive_path, "w") as archive:
            archive.writestr("tblSample.csv", output.getvalue())
            archive.writestr("_export_manifest.json", json.dumps(metadata))
        schema_path = root / "schema.sql"
        schema_path.write_text(SCHEMA, encoding="utf-8")
        return archive_path, schema_path

    def test_import_preserves_null_empty_text_date_and_binary_values(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            archive, schema = self.make_archive(
                root,
                [
                    [1, r"\N", "2025-11-18T12:00:00", "base64:AQI="],
                    [2, "", "2025-11-18T12:00:00", "base64:"],
                    [3, r"\\N", "2025-11-00T12:00:00", "base64:/w=="],
                    [4, "مرحبا", "2025-11-18T12:00:00", "base64:AAE="],
                ],
            )
            output = root / "legacy.sqlite"

            total, counts, invalid_dates = import_export(archive, output, schema)

            self.assertEqual(total, 4)
            self.assertEqual(counts, {"tblSample": 4})
            self.assertEqual(invalid_dates, {"EventDate": 1})
            with sqlite3.connect(output) as database:
                values = database.execute(
                    'SELECT "Name", "EventDate", "Payload" '
                    'FROM "tblSample" ORDER BY "ID"'
                ).fetchall()
            self.assertEqual(values[0], (None, "2025-11-18T12:00:00", b"\x01\x02"))
            self.assertEqual(values[1], ("", "2025-11-18T12:00:00", b""))
            self.assertEqual(values[2], (r"\N", "2025-11-00T12:00:00", b"\xff"))
            self.assertEqual(values[3], ("مرحبا", "2025-11-18T12:00:00", b"\x00\x01"))

    def test_constraint_failure_does_not_leave_partial_database(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            archive, schema = self.make_archive(
                root,
                [
                    [1, "same", "2025-11-18T12:00:00", "base64:"],
                    [2, "same", "2025-11-18T12:00:00", "base64:"],
                ],
            )
            output = root / "legacy.sqlite"

            with self.assertRaisesRegex(ValueError, "constraint check failed"):
                import_export(archive, output, schema)

            self.assertFalse(output.exists())
            self.assertEqual(list(root.glob(".legacy.sqlite.*.partial")), [])

    def test_requires_export_manifest_and_refuses_to_overwrite_database(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            archive = root / "missing-manifest.zip"
            with zipfile.ZipFile(archive, "w") as zip_file:
                zip_file.writestr("tblSample.csv", "ID,Name,EventDate,Payload\n")
            schema = root / "schema.sql"
            schema.write_text(SCHEMA, encoding="utf-8")
            output = root / "legacy.sqlite"
            output.write_text("existing", encoding="utf-8")

            with self.assertRaisesRegex(FileExistsError, "already exists"):
                import_export(archive, output, schema)
            output.unlink()

            with self.assertRaisesRegex(ValueError, "no Access export manifest"):
                import_export(archive, output, schema)

            self.assertFalse(output.exists())


if __name__ == "__main__":
    unittest.main()
