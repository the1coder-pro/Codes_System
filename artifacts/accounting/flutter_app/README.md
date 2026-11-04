# المحاسبة المالية العامة — Flutter UI

Arabic RTL accounting workstation (Flutter web). Files in `lib/`:
- `shell.dart` window chrome: title strip, menus, ribbon, blue canvas, status bar
- `inventory_screen.dart` item card (cyan form, actions, unit grid, search)
- `invoice_menu.dart` green bilingual invoice-type menu
- `invoice_screen.dart` invoice form, tabs, sidebar payments, totals, drafts
- `widgets.dart`, `models.dart`, `storage.dart` (shared_preferences), `theme.dart`

Local font: `assets/fonts/NotoSansArabic-Regular.ttf`. No icon fonts used.
Build: `flutter build web --release --no-web-resources-cdn`
