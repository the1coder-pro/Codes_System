# Run the accounting system locally on macOS

The full system is on the repository's `main` branch. The `flutter-only` branch
contains the Flutter app but not the API server.

## Requirements

- macOS with Xcode command-line tools
- Node.js and pnpm
- Flutter SDK

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

Launch the built `accounting_ui.app` companion on the same Mac and leave it
running. In the browser app, open **الإدارة → إدارة الطابعات**, pair using the
token shown by the companion, and select the invoice and barcode printers.
