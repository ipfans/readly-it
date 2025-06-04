import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService storage;
  Settings _settings;

  SettingsProvider(this.storage) : _settings = storage.settings;

  Settings get settings => _settings;

  Future<void> update(Settings settings) async {
    _settings = settings;
    await storage.updateSettings(settings);
    notifyListeners();
  }
}
