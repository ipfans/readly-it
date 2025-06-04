import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readlyit/models/reading_item.dart';
import 'package:readlyit/providers/reading_list_provider.dart';
import 'package:readlyit/providers/storage_provider.dart';
import 'package:readlyit/services/memory_storage_service.dart';

void main() {
  test('adds and imports items', () async {
    final container = ProviderContainer(overrides: [
      storageProvider.overrideWithValue(MemoryStorageService()),
    ]);

    final notifier = container.read(readingListProvider.notifier);

    await notifier.add('https://example.com');
    expect(container.read(readingListProvider).length, 1);

    await notifier.import([ReadingItem(url: 'https://foo')]);
    expect(container.read(readingListProvider).length, 2);
  });
}
