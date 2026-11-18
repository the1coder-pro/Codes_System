@TestOn('browser')
library;

import 'package:accounting_ui/local_sqlite_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('opens the local SQLite database in a browser', () async {
    SharedPreferences.setMockInitialValues({'items_v1': '[]'});
    final backend = SqliteSettingsStore();
    addTearDown(backend.close);

    await backend.initialize();
    await backend.setString('web-smoke', 'ready');
    expect(await backend.getString('web-smoke'), 'ready');
    expect(await backend.getString('items_v1'), '[]');
  });
}
