import '../models/reading_item.dart';
import '../models/settings.dart';
import 'storage_service.dart';

/// In-memory implementation used for tests.
class MemoryStorageService implements StorageService {
  final List<ReadingItem> _items = [];
  Settings _settings = Settings();

  @override
  List<ReadingItem> get items => List.unmodifiable(_items);

  @override
  Settings get settings => _settings;

  @override
  Future<void> addItem(ReadingItem item) async {
    _items.add(item);
  }

  @override
  Future<void> importItems(List<ReadingItem> items) async {
    _items.addAll(items);
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    _settings = settings;
  }
}
