import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late Settings _temp;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _temp = settings;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(child: Text(loc.fontSize)),
                  Slider(
                    min: 12,
                    max: 24,
                    value: _temp.fontSize,
                    onChanged: (v) =>
                        setState(() => _temp = _temp.copyWith(fontSize: v)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(loc.theme),
              trailing: DropdownButton<ThemeMode>(
                value: _temp.themeMode,
                onChanged: (mode) =>
                    setState(() => _temp = _temp.copyWith(themeMode: mode)),
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(loc.language),
              trailing: DropdownButton<Locale>(
                value: _temp.locale,
                onChanged: (l) => setState(() => _temp = _temp.copyWith(locale: l)),
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                  DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                  DropdownMenuItem(value: Locale('ja'), child: Text('日本語')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile.adaptive(
              title: Text(loc.readingMode),
              value: _temp.readingMode,
              onChanged: (v) =>
                  setState(() => _temp = _temp.copyWith(readingMode: v)),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).update(_temp);
              Navigator.of(context).pop();
            },
            child: Text(loc.ok),
          ),
        ],
      ),
    );
  }
}
