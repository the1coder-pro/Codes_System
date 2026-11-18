import 'package:accounting_ui/local_sqlite_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('migrates existing app data once and keeps the source copy', () async {
    SharedPreferences.setMockInitialValues({
      'items_v1': '[{"id":"old-item","nameAr":"صنف قديم","units":[]}]',
      'invoice_next_number_v1': 17,
      'unrelated_plugin_key': 'must not be copied',
    });
    final backend = SqliteSettingsStore(executor: NativeDatabase.memory());
    addTearDown(backend.close);

    await backend.initialize();
    expect(
      await backend.getString('items_v1'),
      '[{"id":"old-item","nameAr":"صنف قديم","units":[]}]',
    );
    expect(await backend.getInt('invoice_next_number_v1'), 17);
    expect(await backend.get('unrelated_plugin_key'), isNull);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('items_v1'), contains('old-item'));
    await preferences.setString('items_v1', 'changed-after-migration');
    await backend.initialize();
    expect(
      await backend.getString('items_v1'),
      '[{"id":"old-item","nameAr":"صنف قديم","units":[]}]',
    );
  });

  test('persists typed settings and removes only the requested key', () async {
    SharedPreferences.setMockInitialValues({});
    final backend = SqliteSettingsStore(executor: NativeDatabase.memory());
    addTearDown(backend.close);

    expect(await backend.setString('printer', 'Printer A'), isTrue);
    expect(await backend.setInt('copies', 3), isTrue);
    expect(await backend.getString('printer'), 'Printer A');
    expect(await backend.getInt('copies'), 3);
    expect(await backend.getKeys(), containsAll(['printer', 'copies']));
    expect(await backend.remove('printer'), isTrue);
    expect(await backend.get('printer'), isNull);
    expect(await backend.getInt('copies'), 3);
  });
}
