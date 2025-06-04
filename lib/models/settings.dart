import 'dart:convert';
import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;
  final Locale locale;

  Settings({
    this.themeMode = ThemeMode.system,
    this.fontSize = 14,
    this.fontFamily = 'System',
    this.locale = const Locale('en'),
  });

  Settings copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    String? fontFamily,
    Locale? locale,
  }) =>
      Settings(
        themeMode: themeMode ?? this.themeMode,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        locale: locale ?? this.locale,
      );

  Map<String, dynamic> toMap() => {
        'themeMode': themeMode.index,
        'fontSize': fontSize,
        'fontFamily': fontFamily,
        'locale': locale.toLanguageTag(),
      };

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
        themeMode: ThemeMode.values[map['themeMode'] as int],
        fontSize: (map['fontSize'] as num).toDouble(),
        fontFamily: map['fontFamily'] as String,
        locale: Locale.fromSubtags(languageCode: map['locale'] as String),
      );

  String toJson() => jsonEncode(toMap());
  factory Settings.fromJson(String source) =>
      Settings.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
