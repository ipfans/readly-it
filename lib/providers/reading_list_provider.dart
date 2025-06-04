import 'package:flutter/material.dart';

import '../models/reading_item.dart';
import '../services/storage_service.dart';

class ReadingListProvider extends ChangeNotifier {
  final StorageService storage;
  ReadingListProvider(this.storage);

  List<ReadingItem> get items => storage.items;

  Future<void> add(String url, {String? title}) async {
    await storage.addItem(ReadingItem(url: url, title: title));
    notifyListeners();
  }

  Future<void> import(List<ReadingItem> items) async {
    await storage.importItems(items);
    notifyListeners();
  }
}
