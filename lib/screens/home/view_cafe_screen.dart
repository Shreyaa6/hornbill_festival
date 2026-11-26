import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firebase_service.dart';
import '../../widgets/cafe_image.dart';

class ViewCafeScreen extends StatelessWidget {
  final Map<String, dynamic> cafe;

  const ViewCafeScreen({super.key, required this.cafe});

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;

    final name = cafe["cafeName"] ?? cafe["name"] ?? "Café";
    final cafeId = cafe["cafeID"] ?? cafe["docId"] ?? cafe["id"];

    FirebaseService().logServiceQuery(
      serviceType: 'cafe',
      serviceName: name.toString(),
      serviceId: (cafe["docId"] ?? cafe["id"] ?? cafeId ?? "").toString(),
      providerId: cafe["cafeID"]?.toString(),
      providerPhone: cleanPhone,
      district: cafe["district"]?.toString(),
      action: 'call',
    );

    final uri = Uri.parse('tel:$cleanPhone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  void _openMenuModal(BuildContext context, List<String?> menuUrls, int initialIndex, String localMenu) {
    final validUrls = menuUrls.isNotEmpty ? menuUrls : <String?>[null];
    int currentPage = initialIndex.clamp(0, validUrls.length - 1);
    final pageController = PageController(initialPage: currentPage);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 300,
                maxHeight: MediaQuery.of(context).size.height * 0.82,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  // Menu Image(s) with Pinch to Zoom + PageView
                  PageView.builder(
                    controller: pageController,
                    itemCount: validUrls.length,
                    onPageChanged: (idx) {
                      setModalState(() {
                        currentPage = idx;
                      });
                    },
                    itemBuilder: (ctx, idx) {
                      final url = validUrls[idx];
                      return InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: CafeImage(
                          photoUrl: url,
                          localAsset: idx == 0 ? localMenu : '',
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),

                  // Page Counter badge if > 1 image
                  if (validUrls.length > 1)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentPage + 1} / ${validUrls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Floating Close Button with White Circular Background
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF1E293B),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docId = cafe['docId']?.toString() ?? '';
    final name = cafe['name'] ?? cafe['cafeName'] ?? 'Axone kitchen';
    final location = cafe['location'] ?? cafe['address'] ?? 'CY Complex, Opp. Rengma Church , Nagaland';
    final phone = cafe['phone'] ?? cafe['phoneNumber'] ?? '6009516476';
    final localBanner = cafe['localBanner'] as String? ??
        (docId.isNotEmpty ? 'assets/images/cafes/${docId}_banner.jpg' : null) ??
        cafe['photoAsset'] as String? ??
        'assets/images/cafe_axone_banner.png';
    final localMenu = cafe['localMenu'] as String? ??
        (docId.isNotEmpty ? 'assets/images/cafes/${docId}_menu.jpg' : null) ??
        cafe['menuAsset'] as String? ??
        'assets/images/cafe_axone_menu.png';
    final photoUrl = cafe['photo'] as String?;
    final List<String?> menuUrls = [];
    if (cafe['menu'] is List) {
      for (final item in cafe['menu'] as List) {
        final str = item?.toString().trim();
        if (str != null && str.isNotEmpty) {
          menuUrls.add(str);
        }
      }
    } else if (cafe['menu'] is String && (cafe['menu'] as String).trim().isNotEmpty) {
      menuUrls.add((cafe['menu'] as String).trim());
    }

    if (menuUrls.isEmpty && cafe['menuUrl'] != null) {
      if (cafe['menuUrl'] is List) {
        for (final item in cafe['menuUrl'] as List) {
          final str = item?.toString().trim();
          if (str != null && str.isNotEmpty) {
            menuUrls.add(str);
          }
        }
      } else if (cafe['menuUrl'] is String && (cafe['menuUrl'] as String).trim().isNotEmpty) {
        menuUrls.add((cafe['menuUrl'] as String).trim());
      }
    }

    if (menuUrls.isEmpty && (localMenu.isNotEmpty)) {
      menuUrls.add(null);
    }

    final cuisinesList = [
      'Naga Cuisines',
      'Vegetarian Only',
      'Fast Food',
      'North Indian',
      'South Indian',
      'Chinese / Korean Cuisines',
      'Continental',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Photo
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: CafeImage(
                        photoUrl: photoUrl,
                        localAsset: localBanner,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Circular White Buttons on Hero
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),

                            // Phone Call Button
                            GestureDetector(
                              onTap: () => _makeCall(phone),
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Curved White Sheet Details
                Transform.translate(
                  offset: const Offset(0, -18),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cafe Name
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Address / Location
                        Text(
                          location,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Phone Row
                        InkWell(
                          onTap: () => _makeCall(phone),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  size: 22,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Divider
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        const SizedBox(height: 18),

                        // Cuisines Serving Heading
                        const Text(
                          'Cuisines Serving',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Cuisines Wrap
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: cuisinesList.map((cuisine) {
                            final clean = cuisine.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
                            bool hasCuisine = false;
                            if (clean.contains('chinese') || clean.contains('korean')) {
                              hasCuisine = cafe['isChinese'] == true;
                            } else if (clean.contains('continental')) {
                              hasCuisine = cafe['isContinental'] == true;
                            } else if (clean.contains('fastfood')) {
                              hasCuisine = cafe['isFastFood'] == true;
                            } else if (clean.contains('naga')) {
                              hasCuisine = cafe['isNagaDishes'] == true;
                            } else if (clean.contains('northindian')) {
                              hasCuisine = cafe['isNorthIndian'] == true;
                            } else if (clean.contains('southindian')) {
                              hasCuisine = cafe['isSouthIndian'] == true;
                            } else if (clean.contains('veg')) {
                              hasCuisine = cafe['isVegetarian'] == true;
                            }
                            if (!hasCuisine && cafe['cuisines'] is List) {
                              hasCuisine = (cafe['cuisines'] as List).any((c) =>
                                  c.toString().toLowerCase().replaceAll(RegExp(r'[^a-z]'), '').contains(clean));
                            }

                            if (hasCuisine) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD2F5EC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF20B08D),
                                  ),
                                ),
                                child: Text(
                                  cuisine,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00796B),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                cuisine,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Menu Heading with tap action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Menu',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                if (menuUrls.length > 1) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F8F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${menuUrls.length} pages',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF20B08D),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _openMenuModal(context, menuUrls, 0, localMenu),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F7F2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.zoom_in_rounded,
                                      size: 15,
                                      color: Color(0xFF20B08D),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tap to view',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF20B08D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Menu Images: 2 in a row grid if > 1, single full card if 1
                        if (menuUrls.length > 1)
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: menuUrls.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              final url = menuUrls[index];
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _openMenuModal(context, menuUrls, index, localMenu),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CafeImage(
                                          photoUrl: url,
                                          localAsset: index == 0 ? localMenu : '',
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.65),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.menu_book_rounded, color: Colors.white, size: 12),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Page ${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.55),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.fullscreen_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _openMenuModal(context, menuUrls, 0, localMenu),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    CafeImage(
                                      photoUrl: menuUrls.isNotEmpty ? menuUrls.first : null,
                                      localAsset: localMenu,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 12,
                                      bottom: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.fullscreen_rounded, color: Colors.white, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'View Menu',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
