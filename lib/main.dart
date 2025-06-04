import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'providers/reading_list_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/storage_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HiveStorageService.create();
  runApp(
    ProviderScope(
      overrides: [storageProvider.overrideWithValue(storage)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final baseTextTheme = ThemeData.light().textTheme.apply(
          fontSizeFactor: settings.fontSize / 14,
          fontFamily: settings.fontFamily == 'System' ? null : settings.fontFamily,
        );
    return MaterialApp(
      title: 'ReadlyIt',
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        textTheme: baseTextTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        textTheme: baseTextTheme,
      ),
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh'), Locale('ja')],
      routes: {
        '/': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
