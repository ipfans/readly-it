import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/reading_item.dart';
import '../providers/reading_list_provider.dart';
import 'article_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
      ref.read(readingListProvider.notifier).add(value);
    }
  }

  Future<void> _importPocket() async {
    final loc = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final text = await file.readAsString();
      final items = _parsePocketExport(text);
      await ref.read(readingListProvider.notifier).import(items);
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
    final items = ref.watch(readingListProvider);
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                title: Text(item.title ?? item.url),
                subtitle: Text(item.url),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openUrl(item.url),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openUrl(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleScreen(url: url)),
    );
  }
}
