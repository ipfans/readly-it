import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:icloud_storage/icloud_storage.dart';

import '../models/reading_item.dart';
import '../models/settings.dart';

/// Abstraction for persisting reading items and app settings.
abstract class StorageService {
  List<ReadingItem> get items;
  Settings get settings;

  Future<void> addItem(ReadingItem item);
  Future<void> importItems(List<ReadingItem> items);
  Future<void> updateSettings(Settings settings);
}

/// Hive based implementation with optional iCloud sync on iOS.
class HiveStorageService implements StorageService {
  static const _itemsBox = 'itemsBox';
  static const _settingsBox = 'settingsBox';
  static const _icloudContainer = 'iCloud.com.example.readlyit';
  static const _icloudFile = 'items.json';

  late final Box _items;
  late final Box _settings;

  HiveStorageService._();

  static Future<HiveStorageService> create() async {
    if (!kIsWeb) {
      Directory dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    } else {
      await Hive.initFlutter();
    }
    final service = HiveStorageService._();
    service._items = await Hive.openBox(_itemsBox);
    service._settings = await Hive.openBox(_settingsBox);
    if (!kIsWeb && Platform.isIOS) {
      await service._downloadFromICloud();
    }
    return service;
  }

  List<ReadingItem> get items =>
      _items.values.map((e) => ReadingItem.fromMap(Map<String, dynamic>.from(e))).toList();

  Settings get settings => _settings.isNotEmpty
      ? Settings.fromMap(Map<String, dynamic>.from(_settings.get('settings')))
      : Settings();

  Future<void> addItem(ReadingItem item) async {
    await _items.add(item.toMap());
    await _syncToICloud();
  }

  Future<void> importItems(List<ReadingItem> items) async {
    for (final item in items) {
      await _items.add(item.toMap());
    }
    await _syncToICloud();
  }

  Future<void> updateSettings(Settings settings) async {
    await _settings.put('settings', settings.toMap());
  }

  Future<void> _syncToICloud() async {
    if (!kIsWeb && Platform.isIOS) {
      final file = await _localFile();
      await file.writeAsString(jsonEncode(_items.toMap()));
      await ICloudStorage.upload(
        containerId: _icloudContainer,
        filePath: file.path,
        destinationRelativePath: _icloudFile,
      );
    }
  }

  Future<void> _downloadFromICloud() async {
    try {
      final file = await _localFile();
      await ICloudStorage.download(
        containerId: _icloudContainer,
        relativePath: _icloudFile,
        destinationFilePath: file.path,
      );
      final map = jsonDecode(await file.readAsString()) as Map;
      await _items.clear();
      for (final e in map.values) {
        await _items.add(e);
      }
    } catch (_) {
      // ignore errors if file doesn't exist
    }
  }

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_icloudFile');
  }
}
