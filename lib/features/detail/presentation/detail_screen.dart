import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/features/detail/domain/model/web_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.page});

  final WebPage page;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const _primaryColor = Color(0xFF2196F3);

  late final WebViewController _controller;
  late String _title;
  late bool _isCollected;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _title = widget.page.title.trim().isEmpty ? '加载中...' : widget.page.title;
    _isCollected = widget.page.isCollected;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _progress = progress;
              });
            }
          },
          onPageFinished: (url) async {
            final pageTitle = await _controller.getTitle();
            if (!mounted) {
              return;
            }
            setState(() {
              if (pageTitle != null && pageTitle.trim().isNotEmpty) {
                _title = pageTitle;
              }
              _progress = 100;
            });
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('网页加载失败：${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.page.url));
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.tryParse(widget.page.url);
    if (uri == null) {
      _showMessage('链接无效，无法打开浏览器');
      return;
    }

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success && mounted) {
      _showMessage('无法用浏览器打开当前链接');
    }
  }

  Future<void> _sharePage() async {
    await SharePlus.instance.share(
      ShareParams(text: '$_title ${widget.page.url}'),
    );
  }

  void _toggleCollect() {
    setState(() {
      _isCollected = !_isCollected;
    });
    _showMessage(_isCollected ? '已收藏（本地演示）' : '已取消收藏（本地演示）');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        if (await _handleBack() && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          title: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis),
          leading: IconButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (await _handleBack() && mounted) {
                navigator.pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: _toggleCollect,
              icon: Icon(_isCollected ? Icons.favorite : Icons.favorite_border),
              tooltip: '收藏',
            ),
            IconButton(
              onPressed: _sharePage,
              icon: const Icon(Icons.share),
              tooltip: '分享',
            ),
            IconButton(
              onPressed: _controller.reload,
              icon: const Icon(Icons.refresh),
              tooltip: '刷新',
            ),
            IconButton(
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_browser),
              tooltip: '浏览器打开',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_progress < 100 ? 2 : 0),
            child: _progress < 100
                ? LinearProgressIndicator(
                    value: _progress / 100,
                    minHeight: 2,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
