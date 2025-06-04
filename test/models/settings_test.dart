import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readlyit/models/settings.dart';

void main() {
  test('copyWith returns updated values', () {
    final s = Settings();
    final updated = s.copyWith(fontSize: 18, locale: const Locale('ja'));
    expect(updated.fontSize, 18);
    expect(updated.locale.languageCode, 'ja');
    expect(updated.themeMode, s.themeMode);
  });

  test('serialize and deserialize', () {
    final settings = Settings(
      themeMode: ThemeMode.dark,
      fontSize: 16,
      fontFamily: 'Roboto',
      locale: const Locale('zh'),
      readingMode: true,
    );
    final json = settings.toJson();
    final from = Settings.fromJson(json);
    expect(from.themeMode, settings.themeMode);
    expect(from.fontSize, settings.fontSize);
    expect(from.fontFamily, settings.fontFamily);
    expect(from.locale, settings.locale);
    expect(from.readingMode, settings.readingMode);
  });
}
