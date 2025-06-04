import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reading_item.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class ReadingListNotifier extends StateNotifier<List<ReadingItem>> {
  final StorageService storage;
  ReadingListNotifier(this.storage) : super(storage.items);

  Future<void> add(String url, {String? title}) async {
    await storage.addItem(ReadingItem(url: url, title: title));
    state = storage.items;
  }

  Future<void> import(List<ReadingItem> items) async {
    await storage.importItems(items);
    state = storage.items;
  }
}

final readingListProvider =
    StateNotifierProvider<ReadingListNotifier, List<ReadingItem>>((ref) {
  final storage = ref.watch(storageProvider);
  return ReadingListNotifier(storage);
});
