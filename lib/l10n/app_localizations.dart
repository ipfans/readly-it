import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'Read It Later',
      'settings': 'Settings',
      'import_pocket': 'Import Pocket File',
      'font_size': 'Font Size',
      'font_family': 'Font',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'reading_mode': 'Reading Mode',
      'ok': 'OK',
    },
    'zh': {
      'app_title': '稍后阅读',
      'settings': '设置',
      'import_pocket': '导入 Pocket 文件',
      'font_size': '字体大小',
      'font_family': '字体',
      'theme': '主题',
      'dark_mode': '深色模式',
      'language': '语言',
      'reading_mode': '阅读模式',
      'ok': '确定',
    },
    'ja': {
      'app_title': '後で読む',
      'settings': '設定',
      'import_pocket': 'Pocket ファイルをインポート',
      'font_size': '文字サイズ',
      'font_family': 'フォント',
      'theme': 'テーマ',
      'dark_mode': 'ダークモード',
      'language': '言語',
      'reading_mode': 'リーディングモード',
      'ok': 'OK',
    },
  };

  String _text(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get appTitle => _text('app_title');
  String get settings => _text('settings');
  String get importPocket => _text('import_pocket');
  String get fontSize => _text('font_size');
  String get fontFamily => _text('font_family');
  String get theme => _text('theme');
  String get darkMode => _text('dark_mode');
  String get language => _text('language');
  String get readingMode => _text('reading_mode');
  String get ok => _text('ok');

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
