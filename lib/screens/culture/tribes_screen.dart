import 'package:flutter/foundation.dart';
import '../../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/tribe.dart';
import '../../data/app_data.dart';
import '../../services/firebase_service.dart';

class TribesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final String? initialQuery;

  const TribesScreen({
    super.key,
    this.onBack,
    this.initialQuery,
  });

  @override
  State<TribesScreen> createState() => _TribesScreenState();
}

class _TribesScreenState extends State<TribesScreen> {
  // Currently expanded tribe key (unique docId/key so only 1 item ever expands).
  String? _expandedKey;
  bool _didInitExpansion = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      final queryLower = widget.initialQuery!.toLowerCase();
      final match = AppData.tribes.indexWhere(
        (t) =>
            t.name.toLowerCase().contains(queryLower) ||
            t.district.toLowerCase().contains(queryLower),
      );
      if (match != -1) {
        _expandedKey = AppData.tribes[match].uniqueKey;
        _didInitExpansion = true;
      }
    }
  }

  void _toggleExpansion(String key) {
    setState(() {
      if (_expandedKey == key) {
        _expandedKey = null;
      } else {
        _expandedKey = key;
      }
    });
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  static String getLocalAssetForTribe(int id, [String? name]) {
    if (name != null && name.isNotEmpty) {
      final lower = name.toLowerCase().trim();
      if (lower.contains('angami')) return 'assets/images/tribes/1_angami.webp';
      if (lower.contains('ao')) return 'assets/images/tribes/2_ao.webp';
      if (lower.contains('chakhesang')) return 'assets/images/tribes/3_chakhesang.webp';
      if (lower.contains('chang')) return 'assets/images/tribes/4_chang.webp';
      if (lower.contains('garo')) return 'assets/images/tribes/5_garo.webp';
      if (lower.contains('kachari')) return 'assets/images/tribes/6_kachari.webp';
      if (lower.contains('khiamniungan') || lower.contains('khiam')) return 'assets/images/tribes/7_khiamniungan.webp';
      if (lower.contains('konyak')) return 'assets/images/tribes/8_konyak.webp';
      if (lower.contains('kuki')) return 'assets/images/tribes/9_kuki.webp';
      if (lower.contains('lotha')) return 'assets/images/tribes/10_lotha.webp';
      if (lower.contains('phom')) return 'assets/images/tribes/11_phom.webp';
      if (lower.contains('pochury')) return 'assets/images/tribes/12_pochury.webp';
      if (lower.contains('rengma')) return 'assets/images/tribes/13_rengma.webp';
      if (lower.contains('sangtam')) return 'assets/images/tribes/14_sangtam.webp';
      if (lower.contains('sumi')) return 'assets/images/tribes/15_sumi.webp';
      if (lower.contains('tikhir')) return 'assets/images/tribes/16_tikhir.webp';
      if (lower.contains('yimkhiung') || lower.contains('yimchunger')) return 'assets/images/tribes/17_yimkhiung.webp';
      if (lower.contains('zeliang')) return 'assets/images/tribes/18_zeliang.webp';
    }

    switch (id) {
      case 1:
        return 'assets/images/tribes/1_angami.webp';
      case 2:
        return 'assets/images/tribes/2_ao.webp';
      case 3:
        return 'assets/images/tribes/3_chakhesang.webp';
      case 4:
        return 'assets/images/tribes/4_chang.webp';
      case 5:
        return 'assets/images/tribes/5_garo.webp';
      case 6:
        return 'assets/images/tribes/6_kachari.webp';
      case 7:
        return 'assets/images/tribes/7_khiamniungan.webp';
      case 8:
        return 'assets/images/tribes/8_konyak.webp';
      case 9:
        return 'assets/images/tribes/9_kuki.webp';
      case 10:
        return 'assets/images/tribes/10_lotha.webp';
      case 11:
        return 'assets/images/tribes/11_phom.webp';
      case 12:
        return 'assets/images/tribes/12_pochury.webp';
      case 13:
        return 'assets/images/tribes/13_rengma.webp';
      case 14:
        return 'assets/images/tribes/14_sangtam.webp';
      case 15:
        return 'assets/images/tribes/15_sumi.webp';
      case 16:
        return 'assets/images/tribes/16_tikhir.webp';
      case 17:
        return 'assets/images/tribes/17_yimkhiung.webp';
      case 18:
        return 'assets/images/tribes/18_zeliang.webp';
      default:
        return 'assets/images/tribes/1_angami.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: AppTheme.needsBottomSafeArea(context),
        child: StreamBuilder<List<Tribe>>(
        stream: FirebaseService().getTribesStream(),
        initialData: AppData.tribes,
        builder: (context, snapshot) {
          final tribes = snapshot.data ?? AppData.tribes;
          if (!_didInitExpansion && tribes.isNotEmpty) {
            _expandedKey = tribes.first.uniqueKey;
            _didInitExpansion = true;
          }

          return Stack(
            children: [
              // Scrollable Content matching FestivalsScreen
              SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Hero Banner Image matching Tribes section tile
                    SizedBox(
                      height: 250 + topInset,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/tile_tribes.jpg',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.0, -0.3),
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/tribes_top_hero.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),

                    // White Rounded Body Sheet Overlapping the Banner
                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        padding:
                            EdgeInsets.fromLTRB(16, 22, 16, 120 + bottomInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              'Tribes of Nagaland',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Subtitle
                            Text(
                              '${tribes.length} Tribes',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Divider
                            const Divider(
                              color: Color(0xFFE2E8F0),
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 18),

                            // Section Heading
                            const Text(
                              'Details',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 18 Tribal Accordion Cards (exact layout of FestivalsScreen)
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tribes.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final tribe = tribes[index];
                                final isExpanded =
                                    _expandedKey == tribe.uniqueKey;
                                return _buildTribeAccordionCard(
                                  tribe: tribe,
                                  isExpanded: isExpanded,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Circular Back Button
              Positioned(
                top: topInset > 0 ? topInset + 10 : 20,
                left: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleBack,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF0F172A),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
  }

  Widget _buildTribeAccordionCard({
    required Tribe tribe,
    required bool isExpanded,
  }) {
    final localAsset = getLocalAssetForTribe(tribe.id, tribe.name);
    final districtText = tribe.district.toLowerCase().contains('district')
        ? tribe.district
        : '${tribe.district} district';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Always visible & tappable)
          InkWell(
            onTap: () => _toggleExpansion(tribe.uniqueKey),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Green Numbered Badge (1..18)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF20B08D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${tribe.id}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Tribe Name & District Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tribe.name,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          districtText,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Double Arrow Chevron Indicator
                  Icon(
                    isExpanded
                        ? Icons.keyboard_double_arrow_up_rounded
                        : Icons.keyboard_double_arrow_down_rounded,
                    color: const Color(0xFF475569),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content (Photo & Detailed Text)
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tribe Photo (fixed 16:10 frame prevents layout jump while loading)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: _buildTribePhoto(tribe, localAsset),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Paragraph Description
                  Text(
                    tribe.description,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTribePhoto(Tribe tribe, String localAsset) {
    final photoUrl = tribe.image.trim();
    final hasRemotePhoto = photoUrl.isNotEmpty &&
        (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'));

    if (hasRemotePhoto) {
      final safeUrl = kIsWeb
          ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(photoUrl)}'
          : photoUrl;

      return CachedNetworkImage(
        imageUrl: safeUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        memCacheWidth: 800,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => Container(
          color: const Color(0xFFF1F5F9),
        ),
        errorWidget: (_, __, ___) => Image.asset(
          localAsset,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFF1F5F9),
            alignment: Alignment.center,
            child: const Icon(
              Icons.groups_rounded,
              size: 40,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
      );
    }

    // Local asset fallback when no remote photo URL
    return Image.asset(
      localAsset,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF1F5F9),
        alignment: Alignment.center,
        child: const Icon(
          Icons.groups_rounded,
          size: 40,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
