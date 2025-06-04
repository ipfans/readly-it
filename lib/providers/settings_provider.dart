import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  final StorageService storage;
  SettingsNotifier(this.storage) : super(storage.settings);

  Future<void> update(Settings settings) async {
    state = settings;
    await storage.updateSettings(settings);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  final storage = ref.watch(storageProvider);
  return SettingsNotifier(storage);
});
