#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app_dir="$repo_root/artifacts/accounting/flutter_app"

case "$(uname -s)" in
  Darwin) target="macos" ;;
  Linux) target="linux" ;;
  MINGW*|MSYS*|CYGWIN*) target="windows" ;;
  *)
    echo "Unsupported desktop operating system: $(uname -s)" >&2
    exit 1
    ;;
esac

command -v flutter >/dev/null 2>&1 || {
  echo "Flutter SDK is required to build the companion." >&2
  exit 1
}

cd "$app_dir"
flutter pub get
flutter build "$target" --release

case "$target" in
  macos) output="$app_dir/build/macos/Build/Products/Release/accounting_ui.app" ;;
  linux) output="$app_dir/build/linux/x64/release/bundle/accounting_ui" ;;
  windows) output="$app_dir/build/windows/x64/runner/Release/accounting_ui.exe" ;;
esac

printf '\nUnified companion built for %s:\n%s\n' "$target" "$output"
