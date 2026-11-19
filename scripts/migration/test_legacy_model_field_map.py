import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MIGRATION_DIR = ROOT / "artifacts/accounting/flutter_app/migration"


class LegacyModelFieldMapTests(unittest.TestCase):
    def test_mapped_tables_and_columns_match_exact_schema_identifiers(self):
        manifest = json.loads(
            (MIGRATION_DIR / "legacy_schema_manifest.json").read_text(
                encoding="utf-8"
            )
        )
        field_map = json.loads(
            (MIGRATION_DIR / "legacy_model_field_map.json").read_text(
                encoding="utf-8"
            )
        )
        tables = {table["name"]: table for table in manifest["tables"]}

        self.assertEqual(len(field_map["mappings"]), 8)
        for mapping in field_map["mappings"]:
            with self.subTest(model=mapping["model"]):
                self.assertIn(mapping["table"], tables)
                columns = {
                    column["name"] for column in tables[mapping["table"]]["columns"]
                }
                for field in mapping["fields"]:
                    self.assertIn(field["column"], columns)
                    self.assertTrue(field["property"])

    def test_account_spelling_differences_are_explicit_not_normalized(self):
        field_map = json.loads(
            (MIGRATION_DIR / "legacy_model_field_map.json").read_text(
                encoding="utf-8"
            )
        )
        account = next(
            mapping
            for mapping in field_map["mappings"]
            if mapping["model"] == "AccountModel"
        )
        fields = {
            field["property"]: field["column"] for field in account["fields"]
        }
        self.assertEqual(fields["acountNote"], "AcountNote")
        self.assertEqual(fields["MoneyaccountTypeID"], "MoneyAccountTypeID")

    def test_item_balance_identifier_case_is_preserved(self):
        field_map = json.loads(
            (MIGRATION_DIR / "legacy_model_field_map.json").read_text(
                encoding="utf-8"
            )
        )
        balance = next(
            mapping
            for mapping in field_map["mappings"]
            if mapping["model"] == "ItemBalanceModel"
        )
        fields = {
            field["property"]: field["column"] for field in balance["fields"]
        }
        self.assertEqual(
            fields["PackingandUnPackingCount"], "PackingAndUnPackingCount"
        )


if __name__ == "__main__":
    unittest.main()
