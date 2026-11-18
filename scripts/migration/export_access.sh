#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
POM_PATH="$SCRIPT_DIR/access-exporter/pom.xml"
MANIFEST_PATH="$PROJECT_ROOT/artifacts/accounting/flutter_app/migration/legacy_schema_manifest.json"

if ! command -v java >/dev/null 2>&1; then
  echo "Java 11 or newer is required. Install a JDK, then run this script again." >&2
  exit 127
fi
if ! command -v mvn >/dev/null 2>&1; then
  echo "Maven is required. Install Maven, then run this script again." >&2
  exit 127
fi

DATABASE_PATH=
OUTPUT_PATH="$(pwd)/legacy-access-export.zip"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --database)
      [ "$#" -ge 2 ] || { echo "--database needs a file path" >&2; exit 2; }
      DATABASE_PATH=$2
      shift 2
      ;;
    --output)
      [ "$#" -ge 2 ] || { echo "--output needs a file path" >&2; exit 2; }
      OUTPUT_PATH=$2
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 --database /path/to/file.accdb [--output /path/to/export.zip]" >&2
      exit 2
      ;;
  esac
done

if [ -z "$DATABASE_PATH" ]; then
  echo "Usage: $0 --database /path/to/file.accdb [--output /path/to/export.zip]" >&2
  exit 2
fi
if [ ! -f "$DATABASE_PATH" ]; then
  echo "Access database not found: $DATABASE_PATH" >&2
  exit 2
fi
if [ -e "$OUTPUT_PATH" ]; then
  echo "Output already exists; choose another --output path: $OUTPUT_PATH" >&2
  exit 2
fi

ACCESS_DB_PATH=$DATABASE_PATH \
ACCESS_EXPORT_PATH=$OUTPUT_PATH \
LEGACY_SCHEMA_MANIFEST=$MANIFEST_PATH \
  mvn --batch-mode --quiet -f "$POM_PATH" compile exec:java
