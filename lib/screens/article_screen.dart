import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:readability/readability.dart';
import 'package:html/parser.dart' show parse;

import '../providers/settings_provider.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final String url;
  const ArticleScreen({super.key, required this.url});

  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  late WebViewController _controller;
  late bool _readingMode;

  @override
  void initState() {
    super.initState();
    _readingMode = ref.read(settingsProvider).readingMode;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _load();
  }

  Future<void> _load() async {
    if (_readingMode) {
      final html = await _fetchReadableHtml(widget.url);
      await _controller.loadHtmlString(html, baseUrl: widget.url);
    } else {
      await _controller.loadRequest(Uri.parse(widget.url));
    }
  }

  Future<String> _fetchReadableHtml(String url) async {
    final res = await http.get(Uri.parse(url));
    final doc = parse(res.body);
    final article = Readability(Uri.parse(url), doc).parse();
    return '<html><head><meta name="viewport" content="width=device-width, initial-scale=1"><title>${article.title}</title></head><body>${article.content}</body></html>';
  }

  void _toggle() {
    setState(() {
      _readingMode = !_readingMode;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_readingMode ? Icons.chrome_reader_mode : Icons.public),
            onPressed: _toggle,
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
