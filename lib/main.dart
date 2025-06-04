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
  final storage = await StorageService.create();
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
    return MaterialApp(
      title: 'ReadlyIt',
      themeMode: settings.themeMode,
      theme: ThemeData(
        textTheme:
            ThemeData.light().textTheme.apply(fontSizeFactor: settings.fontSize / 14),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme:
            ThemeData.dark().textTheme.apply(fontSizeFactor: settings.fontSize / 14),
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
