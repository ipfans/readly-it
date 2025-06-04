import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readlyit/models/settings.dart';
import 'package:readlyit/providers/settings_provider.dart';
import 'package:readlyit/providers/storage_provider.dart';
import 'package:readlyit/services/memory_storage_service.dart';

void main() {
  test('updates settings', () async {
    final container = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(MemoryStorageService()),
    ]);

    final notifier = container.read(settingsProvider.notifier);
    await notifier.update(const Settings(fontSize: 20));
    expect(container.read(settingsProvider).fontSize, 20);
  });
}
