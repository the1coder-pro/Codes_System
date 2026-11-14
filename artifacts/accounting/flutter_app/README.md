# المحاسبة المالية العامة — Flutter UI

Arabic RTL accounting workstation (Flutter web). Files in `lib/`:
- `shell.dart` window chrome: title strip, menus, ribbon, blue canvas, status bar
- `inventory_screen.dart` item card (cyan form, actions, unit grid, search)
- `invoice_menu.dart` green bilingual invoice-type menu
- `invoice_screen.dart` invoice form, tabs, sidebar payments, totals, drafts
- `widgets.dart`, `models.dart`, `storage.dart` (shared_preferences), `theme.dart`

Local font: `assets/fonts/NotoSansArabic-Regular.ttf`. No icon fonts used.
Build: `flutter build web --release --no-web-resources-cdn`

## Local data backups

In the standalone app, an administrator can use **Tools → Backup** to save a
dated JSON backup containing inventory, accounts, saved invoices, and the next
invoice number. The file contains readable business data, so keep it in a
private location separate from the computer. Restore checks the backup format
and all record structures before asking for confirmation; confirming replaces
the local records. Invalid or unsupported files are rejected without changing
stored records. Restart the app after restoring so every open screen reloads
the restored records.
