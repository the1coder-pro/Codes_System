#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB_DIR="$ROOT/artifacts/accounting/flutter_app/web"

verify_sha256() {
  local file="$1"
  local expected="$2"

  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s  %s\n' "$expected" "$file" | sha256sum --check --status
  elif command -v shasum >/dev/null 2>&1; then
    [[ "$(shasum -a 256 "$file" | awk '{print $1}')" == "$expected" ]]
  else
    echo "A SHA-256 utility (sha256sum or shasum) is required." >&2
    return 1
  fi
}

download_verified() {
  local url="$1"
  local destination="$2"
  local expected_sha256="$3"
  local temporary="${destination}.download"

  if [[ -f "$destination" ]] && verify_sha256 "$destination" "$expected_sha256"; then
    return
  fi

  if ! curl --fail --location --silent --show-error --retry 3 \
    "$url" --output "$temporary"; then
    rm -f "$temporary"
    return 1
  fi
  if ! verify_sha256 "$temporary" "$expected_sha256"; then
    rm -f "$temporary"
    echo "The downloaded file failed its SHA-256 check: $destination" >&2
    return 1
  fi
  mv "$temporary" "$destination"
}

mkdir -p "$WEB_DIR"
download_verified \
  "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.9.4/sqlite3.wasm" \
  "$WEB_DIR/sqlite3.wasm" \
  "922a76b182b6af69b030c8e2fdd3283ecc8e827248b20e4b1f3f3db170b52117"
download_verified \
  "https://github.com/simolus3/drift/releases/download/drift-2.30.1/drift_worker.js" \
  "$WEB_DIR/drift_worker.js" \
  "f0a9b87085f732fd7b6ee7eb34d3858c556f05d221eb1febfc443649cd365752"
