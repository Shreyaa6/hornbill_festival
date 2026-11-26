import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/app_theme.dart';

class AppWebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  final String? subtitle;

  const AppWebViewScreen({
    super.key,
    required this.title,
    required this.url,
    this.subtitle,
  });

  @override
  State<AppWebViewScreen> createState() => _AppWebViewScreenState();
}

class _AppWebViewScreenState extends State<AppWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress / 100.0;
                });
              }
            },
            onPageStarted: (url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onPageFinished: (url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (error) {
              debugPrint('WebView error: ${error.description}');
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        );

      if (widget.url.isNotEmpty) {
        _controller!.loadRequest(Uri.parse(widget.url));
      }
    } catch (e) {
      debugPrint('WebViewController init error: $e');
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Deep Teal Curved Header (matches NotificationsScreen style with NO back button)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.headerTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle ?? 'Hornbill Festival • Official Documents',
                      style: AppTextStyles.headerSubtitle,
                    ),
                  ],
                ),
              ),
            ),

            // White Rounded Body Sheet (matching NotificationsScreen curved sheet)
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: Stack(
                    children: [
                      if (_controller != null)
                        WebViewWidget(controller: _controller!)
                      else
                        const Center(
                          child: Text(
                            'Legal Document',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      if (_isLoading)
                        LinearProgressIndicator(
                          value: _loadingProgress > 0
                              ? _loadingProgress
                              : null,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF20B08D)),
                          minHeight: 3,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
