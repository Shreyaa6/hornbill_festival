import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/firebase_service.dart';
import '../../services/security_service.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String? pdfUrl;

  const PdfViewerScreen({
    super.key,
    required this.title,
    this.pdfUrl,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  WebViewController? _webViewController;
  bool _isLoading = true;
  String? _loadedUrl;

  @override
  void initState() {
    super.initState();
    // Block screenshots and screen recording on Android (FLAG_SECURE)
    SecurityService.enableSecure();

    if (widget.pdfUrl != null && widget.pdfUrl!.trim().isNotEmpty) {
      _initWebView(widget.pdfUrl!.trim());
    }
  }

  @override
  void dispose() {
    // Unblock screenshots when leaving this screen
    SecurityService.disableSecure();
    super.dispose();
  }

  String _formatViewerUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('.pdf') || lower.contains('/o/pdfs') || lower.contains('alt=media')) {
      return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(url)}';
    }
    return url;
  }

  void _initWebView(String url) {
    if (_loadedUrl == url && _webViewController != null) return;
    _loadedUrl = url;
    _isLoading = true;

    final formatted = _formatViewerUrl(url);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(formatted));
  }

  @override
  Widget build(BuildContext context) {
    // If a static pdfUrl was passed, use it directly
    if (widget.pdfUrl != null && widget.pdfUrl!.trim().isNotEmpty) {
      return _buildScaffold(context, widget.pdfUrl!.trim());
    }

    // Otherwise, fetch / stream live from Firestore hornbill/Magazine collection
    return StreamBuilder<String?>(
      stream: FirebaseService().getMagazineUrlStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF20B08D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final liveUrl = snapshot.data;
        if (liveUrl == null || liveUrl.trim().isEmpty) {
          return _buildEmptyState(context);
        }

        _initWebView(liveUrl.trim());
        return _buildScaffold(context, liveUrl.trim());
      },
    );
  }

  Widget _buildScaffold(BuildContext context, String url) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Stack(
                children: [
                  if (_webViewController != null)
                    WebViewWidget(controller: _webViewController!)
                  else
                    _buildEmptyState(context),
                  if (_isLoading)
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(
                            color: Color(0xFF20B08D),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Loading e-Magazine...',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          if (_webViewController != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 22, color: Color(0xFF64748B)),
              onPressed: () => _webViewController?.reload(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        padding: const EdgeInsets.all(22),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F8F3),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/document.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.menu_book_rounded,
                            size: 44,
                            color: Color(0xFF20B08D),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Magazine Available',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The latest Nagaland Tourism e-Magazine has not been published yet. Please check back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF20B08D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Go Back',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
