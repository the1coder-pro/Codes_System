#!/usr/bin/env python3
"""Generate one value-preserving Flutter model for each VB.NET DAL class.

The source DAL is supplied by the user and is not copied into this repository.
The generated catalog records source class/property names and VB types. Database
table mappings are populated only for the eight independently reconciled core
models; all other mappings are explicitly unresolved until verified.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT = ROOT / "artifacts/accounting/flutter_app/lib/dal/models"
DEFAULT_MANIFEST = (
    ROOT
    / "artifacts/accounting/flutter_app/migration/legacy_dal_model_catalog.json"
)
DEFAULT_BARREL = (
    ROOT / "artifacts/accounting/flutter_app/lib/dal/legacy_models.dart"
)
DEFAULT_CATALOG = (
    ROOT / "artifacts/accounting/flutter_app/lib/dal/legacy_model_catalog.dart"
)

CLASS_START = re.compile(
    r"^\s*Public\s+(?:(?:Partial|MustInherit|NotInheritable)\s+)*"
    r"Class\s+([A-Za-z_]\w*)\b",
    re.IGNORECASE,
)
PROPERTY_LINE = re.compile(
    r"^\s*Public\s+"
    r"(?:(?:ReadOnly|WriteOnly|Overridable|Overloads|Overrides|Shared|"
    r"Default|MustOverride|Shadows)\s+)*"
    r"Property\s+"
    r"\[?([A-Za-z_]\w*)\]?\s*(?:\(\s*\))?\s+As\s+(.+?)\s*$",
    re.IGNORECASE,
)
PROPERTY_START = re.compile(r"^\s*Public\s+.*?\bProperty\b", re.IGNORECASE)
END_CLASS = re.compile(r"^\s*End\s+Class\b", re.IGNORECASE)
PUBLIC_FIELD = re.compile(
    r"^\s*Public\s+(?:(?:ReadOnly|Shared|Shadows)\s+)*"
    r"\[?([A-Za-z_]\w*)\]?\s+As\s+(.+?)\s*$",
    re.IGNORECASE,
)

# These relationships were reconciled against the source DAL and the legacy
# schema. Do not infer further table names from a class or file name.
CONFIRMED_TABLES = {
    "ItemGroupModel": "tblItemGroup",
    "ItemModel": "tblItem",
    "ItemOtherDataModel": "tblItemOtherData",
    "ItemBalanceModel": "tblItemBalance",
    "accountModel": "tblAccount",
    "tblInvoiceModel": "tblInvoice",
    "tblInvoiceItemModel": "tblInvoiceItem",
    "tblMoneyTransactionModel": "tblMoneyTransaction",
}

# These existing files also contain their confirmed, adapter-facing table
# definitions. Keep their public file paths stable.
EXISTING_MODEL_FILES = {
    "ItemGroupModel": "item_group_model.dart",
    "ItemModel": "item_model.dart",
    "ItemOtherDataModel": "item_other_data_model.dart",
    "ItemBalanceModel": "item_balance_model.dart",
    "accountModel": "account_model.dart",
    "tblInvoiceModel": "invoice_model.dart",
    "tblInvoiceItemModel": "invoice_item_model.dart",
    "tblMoneyTransactionModel": "money_transaction_model.dart",
}

# Distinguish the source classes whose natural snake_case filename is already
# used by one of the table-mapped models above.
FILE_OVERRIDES = {
    "InvoiceModel": "invoice_model_vb.dart",
    "InvoiceItemModel": "invoice_item_model_vb.dart",
    "MoneyTransactionModel": "money_transaction_model_vb.dart",
}

BEGIN_MARKER = "// BEGIN GENERATED LEGACY SOURCE DEFINITION"
END_MARKER = "// END GENERATED LEGACY SOURCE DEFINITION"
GENERATED_HEADER = "// GENERATED FILE: source model catalog; do not edit by hand."


@dataclass(frozen=True)
class Property:
    name: str
    vb_type: str


@dataclass(frozen=True)
class SourceModel:
    class_name: str
    source_file: str
    properties: tuple[Property, ...]
    source_warnings: tuple[str, ...] = ()


def _strip_vb_comment(value: str) -> str:
    """Remove a trailing VB comment from a type declaration."""
    return value.split("'", 1)[0].strip()


def parse_source(dal_dir: Path) -> list[SourceModel]:
    """Read the Public Class and Public Property declarations in *Model.vb."""
    if not dal_dir.is_dir():
        raise ValueError(f"DAL source directory does not exist: {dal_dir}")

    models: list[SourceModel] = []
    unparsed_properties: list[str] = []
    open_classes: list[tuple[str, Path, list[Property]]] = []
    files = sorted(
        path
        for path in dal_dir.iterdir()
        if path.is_file() and path.name.lower().endswith("model.vb")
    )
    if not files:
        raise ValueError(f"No *Model.vb files found in {dal_dir}")

    for source_file in files:
        text = source_file.read_text(encoding="utf-8-sig", errors="replace")
        open_classes.clear()
        for line_number, line in enumerate(text.splitlines(), start=1):
            class_match = CLASS_START.match(line)
            if class_match:
                open_classes.append(
                    (class_match.group(1), source_file, [])
                )
                continue

            if END_CLASS.match(line):
                if not open_classes:
                    raise ValueError(
                        f"Unexpected End Class at {source_file}:{line_number}"
                    )
                class_name, class_file, properties = open_classes.pop()
                models.append(
                    SourceModel(
                        class_name=class_name,
                        source_file=class_file.name,
                        properties=tuple(properties),
                    )
                )
                continue

            if PROPERTY_START.match(line):
                property_match = PROPERTY_LINE.match(line)
                if not property_match:
                    unparsed_properties.append(
                        f"{source_file.name}:{line_number}: {line.strip()}"
                    )
                    continue
                if not open_classes:
                    raise ValueError(
                        f"Property outside a Public Class at "
                        f"{source_file}:{line_number}"
                    )
                name = property_match.group(1)
                vb_type = _strip_vb_comment(property_match.group(2))
                if not vb_type:
                    unparsed_properties.append(
                        f"{source_file.name}:{line_number}: missing type"
                    )
                    continue
                open_classes[-1][2].append(Property(name, vb_type))

        if open_classes:
            while open_classes:
                class_name, class_file, properties = open_classes.pop()
                models.append(
                    SourceModel(
                        class_name=class_name,
                        source_file=class_file.name,
                        properties=tuple(properties),
                        source_warnings=(
                            f"{class_file.name}: missing End Class before EOF",
                        ),
                    )
                )

    if unparsed_properties:
        preview = "\n".join(unparsed_properties[:30])
        raise ValueError(
            f"Could not parse {len(unparsed_properties)} Public Property "
            f"declaration(s):\n{preview}"
        )

    names = [model.class_name for model in models]
    duplicates = sorted({name for name in names if names.count(name) > 1})
    if duplicates:
        raise ValueError(f"Duplicate VB class names need explicit handling: {duplicates}")

    models.sort(key=lambda model: (model.source_file.casefold(), model.class_name))
    return models


def _dart_string(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def _snake_case(value: str) -> str:
    value = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", value)
    value = re.sub(r"([A-Z])([A-Z][a-z])", r"\1_\2", value)
    return re.sub(r"_+", "_", value).strip("_").lower()


def dart_file_for(model: SourceModel) -> str:
    return EXISTING_MODEL_FILES.get(
        model.class_name,
        FILE_OVERRIDES.get(
            model.class_name,
            f"{_snake_case(model.class_name)}.dart",
        ),
    )


def _source_definition(model: SourceModel, indent: str = "  ") -> str:
    table = CONFIRMED_TABLES.get(model.class_name)
    status = "confirmed" if table else "unresolved"
    table_literal = "null" if table is None else _dart_string(table)
    lines = [
        f"{indent}{BEGIN_MARKER}",
        f"{indent}static const sourceDefinition = LegacySourceModelDefinition(",
        f"{indent}  className: {_dart_string(model.class_name)},",
        f"{indent}  sourceFile: {_dart_string(model.source_file)},",
        f"{indent}  tableName: {table_literal},",
        f"{indent}  tableMappingStatus: "
        f"LegacyModelTableMappingStatus.{status},",
        f"{indent}  properties: [",
    ]
    for prop in model.properties:
        lines.append(
            f"{indent}    LegacySourceProperty("
            f"name: {_dart_string(prop.name)}, "
            f"vbType: {_dart_string(prop.vb_type)}),"
        )
    lines.extend(
        [
            f"{indent}  ],",
            f"{indent});",
            f"{indent}{END_MARKER}",
        ]
    )
    return "\n".join(lines)


def _render_new_model(model: SourceModel) -> str:
    return "\n".join(
        [
            GENERATED_HEADER,
            "// VB.NET source: " + model.source_file,
            "// ignore_for_file: camel_case_types, non_constant_identifier_names",
            "",
            "import '../legacy_model.dart';",
            "",
            f"class {model.class_name} extends LegacySourceModel {{",
            f"  {model.class_name}(Map<String, Object?> values)",
            "    : super(sourceDefinition, values);",
            "",
            _source_definition(model),
            "}",
            "",
        ]
    )


def _update_existing_model(path: Path, model: SourceModel) -> str:
    text = path.read_text(encoding="utf-8")
    generated = _source_definition(model)
    if BEGIN_MARKER in text and END_MARKER in text:
        pattern = re.compile(
            re.escape(BEGIN_MARKER) + r".*?" + re.escape(END_MARKER),
            flags=re.DOTALL,
        )
        return pattern.sub(generated, text, count=1)

    class_pattern = re.compile(
        rf"(^class\s+{re.escape(model.class_name)}\s+extends\s+"
        rf"[A-Za-z_]\w*\s*\{{)",
        flags=re.MULTILINE,
    )
    match = class_pattern.search(text)
    if not match:
        raise ValueError(
            f"Expected existing class {model.class_name} in {path}"
        )
    return (
        text[: match.end()]
        + "\n"
        + generated
        + text[match.end() :]
    )


def render_catalog(models: list[SourceModel]) -> str:
    entries = [
        "  " + model.class_name + ".sourceDefinition,"
        for model in models
    ]
    return "\n".join(
        [
            GENERATED_HEADER,
            "// The source class order is stable by VB file and class name.",
            "import 'legacy_models.dart';",
            "",
            "const legacySourceModelCatalog = <LegacySourceModelDefinition>[",
            *entries,
            "];",
            "",
        ]
    )


def _catalog_entry(model: SourceModel) -> dict[str, object]:
    table = CONFIRMED_TABLES.get(model.class_name)
    return {
        "class_name": model.class_name,
        "source_file": model.source_file,
        "dart_file": dart_file_for(model),
        "properties": [asdict(prop) for prop in model.properties],
        "source_warnings": list(model.source_warnings),
        "table_mapping": {
            "status": "confirmed" if table else "unresolved",
            "table": table,
        },
    }


def render_manifest(models: list[SourceModel]) -> str:
    return json.dumps(
        {
            "source": "CodesSystem/DAL/*Model.vb",
            "model_file_count": len(
                {model.source_file for model in models}
            ),
            "class_count": len(models),
            "property_count": sum(len(model.properties) for model in models),
            "models": [_catalog_entry(model) for model in models],
        },
        ensure_ascii=False,
        indent=2,
    ) + "\n"


def render_barrel(models: list[SourceModel]) -> str:
    files = sorted({dart_file_for(model) for model in models})
    return "\n".join(
        [
            "// Public barrel for the per-class legacy model files.",
            "export 'legacy_model.dart';",
            *[f"export 'models/{filename}';" for filename in files],
            "",
        ]
    )


def _write_or_check(path: Path, content: str, check: bool) -> bool:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            print(f"Out of date: {path}", file=sys.stderr)
            return False
        return True
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return True


def _definition_is_current(path: Path, model: SourceModel) -> bool:
    if not path.is_file():
        print(f"Missing generated model: {path}", file=sys.stderr)
        return False
    content = path.read_text(encoding="utf-8")
    if f"class {model.class_name} extends " not in content:
        print(f"Missing class declaration: {path}", file=sys.stderr)
        return False
    block = re.search(
        re.escape(BEGIN_MARKER) + r".*?" + re.escape(END_MARKER),
        content,
        flags=re.DOTALL,
    )
    if not block:
        print(f"Missing generated source metadata: {path}", file=sys.stderr)
        return False
    body = block.group(0)
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
    table = CONFIRMED_TABLES.get(model.class_name)
    expected = (
        model.class_name,
        model.source_file,
        table,
        "confirmed" if table else "unresolved",
        [(prop.name, prop.vb_type) for prop in model.properties],
    )
    actual = (
        class_name.group(1) if class_name else None,
        source_file.group(1) if source_file else None,
        table_name.group(2) if table_name else None,
        mapping_status.group(1) if mapping_status else None,
        properties,
    )
    if actual != expected:
        print(f"Out of date source metadata: {path}", file=sys.stderr)
        return False
    return True


def generate(
    models: list[SourceModel],
    output_dir: Path,
    manifest_path: Path,
    barrel_path: Path,
    catalog_path: Path,
    check: bool,
) -> bool:
    success = True
    model_by_class = {model.class_name: model for model in models}

    for model in models:
        filename = dart_file_for(model)
        target = output_dir / filename
        if model.class_name in EXISTING_MODEL_FILES:
            if check:
                success &= _definition_is_current(target, model)
            else:
                target.write_text(
                    _update_existing_model(target, model),
                    encoding="utf-8",
                )
        else:
            if check:
                success &= _definition_is_current(target, model)
            else:
                success &= _write_or_check(
                    target,
                    _render_new_model(model),
                    False,
                )

    # Detect accidental filename collisions before publishing generated files.
    files = [dart_file_for(model) for model in models]
    if len(files) != len(set(files)):
        raise ValueError("Two VB model classes resolve to the same Dart filename.")

    success &= _write_or_check(
        manifest_path,
        render_manifest(models),
        check,
    )
    success &= _write_or_check(
        barrel_path,
        render_barrel(models),
        check,
    )
    success &= _write_or_check(
        catalog_path,
        render_catalog(models),
        check,
    )
    return success


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dal-source",
        type=Path,
        required=True,
        help="Path to the legacy CodesSystem/DAL source folder.",
    )
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--barrel", type=Path, default=DEFAULT_BARREL)
    parser.add_argument("--catalog", type=Path, default=DEFAULT_CATALOG)
    parser.add_argument(
        "--check",
        action="store_true",
        help="Verify generated files without writing them.",
    )
    args = parser.parse_args()

    try:
        models = parse_source(args.dal_source.resolve())
        if len(models) != 357:
            raise ValueError(
                f"Expected 357 class declarations, found {len(models)}."
            )
        if not generate(
            models,
            args.output_dir.resolve(),
            args.manifest.resolve(),
            args.barrel.resolve(),
            args.catalog.resolve(),
            args.check,
        ):
            return 1
    except (OSError, ValueError) as error:
        print(error, file=sys.stderr)
        return 2

    action = "Verified" if args.check else "Generated"
    print(
        f"{action} {len(models)} class models from "
        f"{len({model.source_file for model in models})} VB.NET files "
        f"with {sum(len(model.properties) for model in models)} properties."
    )
    for warning in sorted(
        {warning for model in models for warning in model.source_warnings}
    ):
        print(f"Source warning: {warning}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
