import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/reading_item.dart';
import '../providers/reading_list_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ReceiveSharingIntent.getInitialText().then(_handleShared);
    ReceiveSharingIntent.getTextStream().listen(_handleShared);
  }

  void _handleShared(String? value) {
    if (value == null) return;
    final uri = Uri.tryParse(value);
    if (uri != null && (uri.hasScheme && uri.host.isNotEmpty)) {
      final provider =
          context.read<ReadingListProvider>();
      provider.add(value);
    }
  }

  Future<void> _importPocket() async {
    final loc = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final text = await file.readAsString();
      final items = _parsePocketExport(text);
      await context.read<ReadingListProvider>().import(items);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.importPocket)));
      }
    }
  }

  List<ReadingItem> _parsePocketExport(String content) {
    final regex = RegExp(r'<a href="(.*?)"');
    return regex
        .allMatches(content)
        .map((m) => ReadingItem(url: m.group(1)!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final items = context.watch<ReadingListProvider>().items;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importPocket,
            tooltip: loc.importPocket,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            tooltip: loc.settings,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.title ?? item.url),
            subtitle: Text(item.url),
            onTap: () => _openUrl(item.url),
          );
        },
      ),
    );
  }

  void _openUrl(String url) {
    final uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
