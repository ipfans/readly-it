import 'package:flutter_test/flutter_test.dart';
import 'package:readlyit/models/reading_item.dart';

void main() {
  test('serialize and deserialize', () {
    final item = ReadingItem(url: 'https://example.com', title: 'Example');
    final json = item.toJson();
    final from = ReadingItem.fromJson(json);
    expect(from.url, item.url);
    expect(from.title, item.title);
    expect(from.added.isAtSameMomentAs(item.added), true);
  });
}
