import json
import os
import re
import unittest
from pathlib import Path

from generate_flutter_dal_models import parse_source


ROOT = Path(__file__).resolve().parents[2]
MIGRATION_DIR = ROOT / "artifacts/accounting/flutter_app/migration"
MODEL_DIR = ROOT / "artifacts/accounting/flutter_app/lib/dal/models"
SOURCE_DIR = os.environ.get("LEGACY_DAL_SOURCE")


def load_catalog():
    return json.loads(
        (MIGRATION_DIR / "legacy_dal_model_catalog.json").read_text(
            encoding="utf-8"
        )
    )


def dart_source_definition(model):
    source = (MODEL_DIR / model["dart_file"]).read_text(encoding="utf-8")
    declaration = re.search(
        rf"^class\s+{re.escape(model['class_name'])}\s+extends\s+\w+\s*\{{",
        source,
        flags=re.MULTILINE,
    )
    if not declaration:
        raise AssertionError(
            f"{model['class_name']} has no separate Dart model declaration."
        )
    block = re.search(
        r"// BEGIN GENERATED LEGACY SOURCE DEFINITION"
        r"(.*?)"
        r"// END GENERATED LEGACY SOURCE DEFINITION",
        source,
        flags=re.DOTALL,
    )
    if not block:
        raise AssertionError(f"{model['class_name']} has no source metadata.")

    body = block.group(1)
    class_name = re.search(r"className:\s*'([^']*)'", body)
    source_file = re.search(r"sourceFile:\s*'([^']*)'", body)
    table_name = re.search(r"tableName:\s*(null|'([^']*)')", body)
    mapping_status = re.search(
        r"tableMappingStatus:\s*LegacyModelTableMappingStatus\.(\w+)",
        body,
    )
    properties = re.findall(
        r"LegacySourceProperty\(\s*name:\s*'([^']*)'\s*,\s*"
        r"vbType:\s*'([^']*)'\s*,?\s*\)",
        body,
        flags=re.DOTALL,
    )
    if not all((class_name, source_file, table_name, mapping_status)):
        raise AssertionError(
            f"{model['class_name']} has incomplete source metadata."
        )

    return {
        "class_name": class_name.group(1),
        "source_file": source_file.group(1),
        "properties": [
            {"name": name, "vb_type": vb_type}
            for name, vb_type in properties
        ],
        "table_mapping": {
            "status": mapping_status.group(1),
            "table": table_name.group(2),
        },
    }


class LegacyDalCatalogTests(unittest.TestCase):
    def test_catalog_has_all_source_classes_properties_and_separate_files(self):
        catalog = load_catalog()
        models = catalog["models"]

        self.assertEqual(catalog["model_file_count"], 355)
        self.assertEqual(catalog["class_count"], 357)
        self.assertEqual(catalog["property_count"], 2136)
        self.assertEqual(len(models), catalog["class_count"])
        self.assertEqual(
            sum(len(model["properties"]) for model in models),
            catalog["property_count"],
        )
        self.assertEqual(len({model["class_name"] for model in models}), 357)
        self.assertEqual(len({model["dart_file"] for model in models}), 357)

        for model in models:
            with self.subTest(model=model["class_name"]):
                self.assertTrue((MODEL_DIR / model["dart_file"]).is_file())
                self.assertEqual(
                    dart_source_definition(model),
                    {
                        "class_name": model["class_name"],
                        "source_file": model["source_file"],
                        "properties": model["properties"],
                        "table_mapping": model["table_mapping"],
                    },
                )

    def test_source_classes_match_the_original_vb_when_checkout_is_available(self):
        if not SOURCE_DIR:
            self.skipTest("Set LEGACY_DAL_SOURCE to the provided DAL checkout.")

        source_models = parse_source(Path(SOURCE_DIR))
        source = {
            model.class_name: {
                "source_file": model.source_file,
                "properties": [
                    {"name": prop.name, "vb_type": prop.vb_type}
                    for prop in model.properties
                ],
                "source_warnings": list(model.source_warnings),
            }
            for model in source_models
        }
        catalog_models = {
            model["class_name"]: model for model in load_catalog()["models"]
        }
        self.assertEqual(set(source), set(catalog_models))

        for class_name, source_model in source.items():
            with self.subTest(model=class_name):
                catalog_model = catalog_models[class_name]
                self.assertEqual(
                    catalog_model["source_file"],
                    source_model["source_file"],
                )
                self.assertEqual(
                    catalog_model["properties"],
                    source_model["properties"],
                )
                self.assertEqual(
                    catalog_model["source_warnings"],
                    source_model["source_warnings"],
                )

    def test_only_reconciled_models_claim_a_database_table(self):
        catalog = load_catalog()
        schema = json.loads(
            (MIGRATION_DIR / "legacy_schema_manifest.json").read_text(
                encoding="utf-8"
            )
        )
        table_names = {table["name"] for table in schema["tables"]}
        confirmed = [
            model
            for model in catalog["models"]
            if model["table_mapping"]["status"] == "confirmed"
        ]
        unresolved = [
            model
            for model in catalog["models"]
            if model["table_mapping"]["status"] == "unresolved"
        ]

        self.assertEqual(len(confirmed), 8)
        self.assertEqual(len(unresolved), 349)
        for model in confirmed:
            self.assertIn(model["table_mapping"]["table"], table_names)
        for model in unresolved:
            self.assertIsNone(model["table_mapping"]["table"])


if __name__ == "__main__":
    unittest.main()
