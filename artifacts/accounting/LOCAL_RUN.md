# Run the accounting system locally on macOS

The desktop build offers two startup choices: the standalone Flutter system,
or a companion that starts the local web UI, API, and Dart printer service.
The web companion uses Node.js and pnpm installed on the computer; the
standalone Flutter system does not.

## Requirements

- macOS with Xcode command-line tools
- Flutter SDK

## Build the desktop app with both choices

From the Flutter app folder:

```sh
flutter pub get
flutter build macos
open build/macos/Build/Products/Release/*.app
```

The app opens a mode chooser. You can also build directly into one mode with
`--dart-define=PRINTER_COMPANION=true` for the standalone system or
`--dart-define=PRINTER_WEB_COMPANION=true` for the web companion.

## Run the standalone desktop system

From the Flutter app folder. On `main`, first change to
`artifacts/accounting/flutter_app`; on `flutter-only`, the repository root is
already the Flutter app folder.

```sh
flutter pub get
flutter build macos --dart-define=PRINTER_COMPANION=true
open build/macos/Build/Products/Release/*.app
```

The app opens the full accounting system and starts its local printing service.
No Node.js or browser is needed. All data is stored locally on this Mac and
does not sync with the browser app. On first launch, all four roles use password
`1233`; sign in as `admin` and change them under **الإدارة → إدارة كلمات المرور**.

## Run the locally hosted web UI from the companion

This mode needs Node.js, pnpm, the Flutter SDK, and a running PostgreSQL database.
Use a full `main` repository checkout; the `flutter-only` branch does not include
the web or API source code.

From the full repository root, install dependencies and configure `.env` with a
`DATABASE_URL` for the local database:

```sh
pnpm install
```

For a new, empty local database, create its schema once with:

```sh
pnpm --filter @workspace/db run push
```

Only run the schema command against the intended local database; back up any
existing data before changing its schema. Do not commit `.env`.

Build the desktop launcher from `artifacts/accounting/flutter_app` with
`--dart-define=PRINTER_WEB_COMPANION=true`, or use the two-choice build above.
Choose the full repository folder in the companion. It builds the web UI and API,
starts them on `127.0.0.1:24339` and `127.0.0.1:8080`, starts the Dart printer
service, and opens the browser. On the first run, pair the browser UI once with
the printer token shown in the companion. Closing the companion stops its local
services.

## Run the browser version locally

The steps below use the Node API from `main` and run the UI in a browser.
Install Node.js and pnpm before continuing.

From a clone of the full repository, install the workspace dependencies:

```sh
git switch main
pnpm install
```

## Start the API

In the first terminal, from the repository root:

```sh
export SESSION_SECRET="$(openssl rand -hex 32)"
HOST=127.0.0.1 PORT=8080 pnpm --filter @workspace/api-server run dev
```

This development server uses password `1233` for the `admin`, `cashier1`,
`cashier2`, and `auditor` accounts unless `ACCOUNTING_ROLE_PASSWORDS` is set.
Use a separate random `SESSION_SECRET` on each local machine; do not reuse a
production secret.

## Start the accounting UI

In a second terminal, also from the repository root:

```sh
HOST=127.0.0.1 PORT=24339 API_PORT=8080 pnpm --filter @workspace/accounting run dev
```

The local UI server forwards `/api` requests to the API server on port 8080.
Open **http://localhost:24339** in your browser.

## Printing

For manual browser startup, launch the built print-only helper with
`--dart-define=PRINTER_SERVICE_ONLY=true` and leave it running. In the browser
app, open **الإدارة → إدارة الطابعات**, pair using the token shown by the helper,
and select the invoice and barcode printers.
