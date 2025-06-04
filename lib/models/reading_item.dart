import 'dart:convert';

class ReadingItem {
  final String url;
  final String? title;
  final DateTime added;

  ReadingItem({required this.url, this.title, DateTime? added})
      : added = added ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'url': url,
        'title': title,
        'added': added.toIso8601String(),
      };

  factory ReadingItem.fromMap(Map<String, dynamic> map) => ReadingItem(
        url: map['url'] as String,
        title: map['title'] as String?,
        added: DateTime.parse(map['added'] as String),
      );

  String toJson() => jsonEncode(toMap());

  factory ReadingItem.fromJson(String source) =>
      ReadingItem.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
