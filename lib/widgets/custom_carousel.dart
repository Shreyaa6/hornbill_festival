import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> images;
  final double? height;
  final double? aspectRatio;
  final double borderRadius;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final EdgeInsetsGeometry margin;
  final BoxFit fit;

  const CustomCarousel({
    super.key,
    required this.images,
    this.height,
    this.aspectRatio = 16 / 9,
    this.borderRadius = 16,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.fit = BoxFit.cover,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay && widget.images.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentPage + 1) % widget.images.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String? _getCarouselLocalAsset(String url) {
    if (url.contains('thumbnail_1')) return 'assets/images/carousel/thumbnail_1.jpg';
    if (url.contains('thumbnail_4')) return 'assets/images/carousel/thumbnail_4.jpg';
    if (url.contains('thumbnail_5')) return 'assets/images/carousel/thumbnail_5.jpg';
    if (url.contains('thumbnail_6')) return 'assets/images/carousel/thumbnail_6.jpg';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final carouselBody = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final img = widget.images[index];
                if (img.startsWith('assets/')) {
                  return Image.asset(
                    img,
                    fit: widget.fit,
                    width: double.infinity,
                  );
                }
                final localAsset = _getCarouselLocalAsset(img);
                if (kIsWeb && localAsset != null) {
                  return Image.asset(
                    localAsset,
                    fit: widget.fit,
                    width: double.infinity,
                  );
                }
                return CachedNetworkImage(
                  imageUrl: img,
                  fit: widget.fit,
                  width: double.infinity,
                  memCacheWidth: 900,
                  fadeInDuration: const Duration(milliseconds: 120),
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFECECEC),
                  ),
                  errorWidget: (context, url, error) {
                    final local = _getCarouselLocalAsset(url);
                    if (local != null) {
                      return Image.asset(
                        local,
                        fit: widget.fit,
                        width: double.infinity,
                      );
                    }
                    return Image.asset(
                      'assets/images/carousel/thumbnail_1.jpg',
                      fit: widget.fit,
                      width: double.infinity,
                    );
                  },
                );
              },
            ),
            if (widget.images.length > 1)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      width: _currentPage == index ? 16 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (widget.height != null) {
      return Container(
        margin: widget.margin,
        height: widget.height,
        child: carouselBody,
      );
    }

    return Padding(
      padding: widget.margin,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio ?? (16 / 9),
        child: carouselBody,
      ),
    );
  }
}
