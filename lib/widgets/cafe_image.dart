import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CafeImage extends StatelessWidget {
  final String? photoUrl;
  final String? localAsset;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CafeImage({
    super.key,
    required this.photoUrl,
    required this.localAsset,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  static String? getWebSafeUrl(String? url, {int? width, int? quality}) {
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (trimmed.startsWith('http')) {
      // If on web or if resizing/compression is requested, route through Weserv CDN
      if (kIsWeb || width != null || quality != null) {
        var weserv = 'https://images.weserv.nl/?url=${Uri.encodeComponent(trimmed)}';
        if (width != null) weserv += '&w=$width';
        if (quality != null) weserv += '&q=$quality';
        weserv += '&output=webp';
        return weserv;
      }
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final webUrl = getWebSafeUrl(photoUrl);

    // If local asset is available, use it for instant, CORS-free loading
    if (localAsset != null && localAsset!.trim().isNotEmpty) {
      imageWidget = Image.asset(
        localAsset!.trim(),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) {
          if (webUrl != null) {
            return CachedNetworkImage(
              imageUrl: webUrl,
              height: height,
              width: width,
              fit: fit,
              memCacheWidth: 600,
              fadeInDuration: const Duration(milliseconds: 120),
              placeholder: (_, __) => Container(
                height: height,
                width: width,
                color: const Color(0xFFF1F5F9),
              ),
              errorWidget: (_, __, ___) => _fallbackPlaceholder(),
            );
          }
          return _fallbackPlaceholder();
        },
      );
    } else if (webUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: webUrl,
        height: height,
        width: width,
        fit: fit,
        memCacheWidth: 600,
        fadeInDuration: const Duration(milliseconds: 120),
        placeholder: (_, __) => Container(
          height: height,
          width: width,
          color: const Color(0xFFF1F5F9),
        ),
        errorWidget: (_, __, ___) => _fallbackPlaceholder(),
      );
    } else {
      imageWidget = _fallbackPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _fallbackPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(
          Icons.restaurant_outlined,
          size: 40,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
