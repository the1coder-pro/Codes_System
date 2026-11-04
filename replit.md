# Arabic Accounting Flutter UI

Responsive Arabic RTL accounting interface reproducing the user's desktop screenshots in Flutter/Dart.

## Run & Operate

- `pnpm --filter @workspace/accounting run dev` — builds Flutter web and serves it on the managed `PORT`.
- `cd artifacts/accounting/flutter_app && flutter run -d chrome` — standard Flutter development outside the managed preview.
- `cd artifacts/accounting/flutter_app && flutter analyze` — Dart static analysis.
- Flutter SDK is installed through the project's Nix system dependencies.

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/accounting/flutter_app/` — actual Flutter project; source in `lib/`.
- `artifacts/accounting/serve.mjs` — development static hosting for compiled Flutter web.
- The React files left by the artifact bootstrap are not used by the running UI.

## Architecture decisions

- Flutter, not React, is the requested implementation. The web artifact scaffold is only used to register and serve Flutter web.
- This is a UI project, not a production accounting backend. Inventory and invoice drafts use device-local storage.
- Bundle the Arabic font and CanvasKit locally to avoid depending on external font/rendering CDNs.

## Product

_Describe the high-level user-facing capabilities of this app once they exist._

## User preferences

- Preserve the screenshot layout on large screens and adapt it for small screens.
- The main screen is plain blue instead of the original large background graphic/text.
- Keep the top buttons and bottom status bar; inventory replaces the background inside that shell.
- Invoicing opens the green type menu, and selecting a type opens the invoice form.
- No icons for now; text and simple symbols are used.

## Gotchas

_Populate as you build — sharp edges, "always run X before Y" rules._

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
