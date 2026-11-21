import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/tribe.dart';
import '../../data/app_data.dart';
import '../../widgets/custom_bottom_bar.dart';

class TribesScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final String? initialQuery;

  const TribesScreen({
    super.key,
    this.onBack,
    this.initialQuery,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;
    final tribes = AppData.tribes;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Banner Image
                SizedBox(
                  height: 230 + topInset,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/tribes_top_hero.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/tribes_card.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),

                // White Rounded Body Sheet Overlapping the Banner
                Transform.translate(
                  offset: const Offset(0, -26),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding:
                        EdgeInsets.fromLTRB(18, 22, 18, 110 + bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Subtitle
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
                        const Text(
                          '18 Tribes',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13.5,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // List of 18 Tribe Cards with Overlapping Script Title on Top Border
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tribes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 32),
                          itemBuilder: (context, index) {
                            final tribe = tribes[index];
                            return _buildTribeBox(tribe);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Circular Back Button `<`
          Positioned(
            top: topInset + 12,
            left: 16,
            child: GestureDetector(
              onTap: onBack ??
                  () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 26,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),

          // Custom Bottom Navigation Bar
          CustomBottomBar(
            currentIndex: 1, // Cultures tab active
            onTap: (index) {
              if (index != 1) {
                onBack?.call();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTribeBox(Tribe tribe) {
    // Check if we have dedicated local image for top tribes
    String? localAsset;
    switch (tribe.id) {
      case 1:
        localAsset = 'assets/images/tribe_angami.png';
        break;
      case 2:
        localAsset = 'assets/images/tribe_ao.png';
        break;
      case 3:
        localAsset = 'assets/images/tribe_chakhesang.png';
        break;
      case 4:
        localAsset = 'assets/images/tribe_chang.png';
        break;
      case 14:
        localAsset = 'assets/images/tribes/tribe_sangtam.png';
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Outer Box Container with Light Border
        Container(
          margin: const EdgeInsets.only(top: 18),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 24, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tribe Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: localAsset != null
                    ? Image.asset(
                        localAsset,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildNetworkImage(tribe),
                      )
                    : _buildNetworkImage(tribe),
              ),
              const SizedBox(height: 14),

              // Description Text Paragraph
              Text(
                tribe.description,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 13,
                  height: 1.48,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Script Title Centered on Top Border
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: Colors.white, // Masks the top border line behind the text
              child: Text(
                'The ${tribe.name}',
                style: const TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF20B08D),
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImage(Tribe tribe) {
    return CachedNetworkImage(
      imageUrl: tribe.image,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 200,
        color: const Color(0xFFF1F5F9),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 200,
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
