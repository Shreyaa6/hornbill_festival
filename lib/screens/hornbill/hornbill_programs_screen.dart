import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/firebase_service.dart';
import '../../data/contests_data.dart';
import '../../theme/app_theme.dart';

class HornbillProgramsScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const HornbillProgramsScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: AppTheme.needsBottomSafeArea(context),
        child: Column(
          children: [
            // Deep Teal Top Header (matches Notifications / TaxisScreen style)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Programs & Contests',
                      style: AppTextStyles.headerTitle,
                    ),
                    const SizedBox(height: 3),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: FirebaseService().getContests(),
                      builder: (context, snapshot) {
                        final events = snapshot.hasData
                            ? snapshot.data!
                            : ContestsData.allContests.map((c) => c.toMap()).toList();
                        return Text(
                          '${events.length} Events • Festival Lineup',
                          style: AppTextStyles.headerSubtitle,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(18, 22, 18, 120 + bottomInset),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirebaseService().getContests(),
                    builder: (context, snapshot) {
                      final events = snapshot.hasData
                          ? snapshot.data!
                          : ContestsData.allContests.map((c) => c.toMap()).toList();

                      return Column(
                        children: events.map((ev) {
                          final docId = ev['docId']?.toString() ?? '';
                          final localPoster = ev['localPoster']?.toString() ??
                              (docId.isNotEmpty ? 'assets/images/posters/$docId.jpg' : null);
                          final remotePoster = (ev['remotePoster'] ?? ev['poster'])?.toString().trim();

                          // Use bundled asset (0ms) unless Firestore has a new/updated remote URL
                          final isBundledUnchanged = localPoster != null &&
                              localPoster.isNotEmpty &&
                              (remotePoster == null ||
                                  remotePoster.isEmpty ||
                                  ContestsData.allContests.any(
                                    (c) => c.docId == docId && c.poster == remotePoster,
                                  ));

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 26),
                            child: _buildEventCard(
                              title: ev['title']?.toString() ?? 'Hornbill Event',
                              posterAsset: isBundledUnchanged
                                  ? localPoster
                                  : (remotePoster != null && remotePoster.isNotEmpty
                                      ? remotePoster
                                      : localPoster),
                              fallbackAsset: localPoster,
                              description: ev['description']?.toString() ?? '',
                              date: ev['date']?.toString() ?? '',
                              location: ev['location']?.toString() ?? 'Kisama Heritage Village',
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    String? posterAsset,
    String? fallbackAsset,
    required String description,
    required String date,
    required String location,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Title
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 10),

        // Rounded Card Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFECEFF1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image (if available)
              if (posterAsset != null && posterAsset.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: posterAsset.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: posterAsset,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 800,
                          fadeInDuration: const Duration(milliseconds: 120),
                          placeholder: (_, __) => Container(
                            height: 180,
                            color: const Color(0xFFF1F5F9),
                          ),
                          errorWidget: (_, __, ___) =>
                              (fallbackAsset != null && fallbackAsset.isNotEmpty)
                                  ? Image.asset(
                                      fallbackAsset,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const SizedBox(),
                                    )
                                  : const SizedBox(),
                        )
                      : Image.asset(
                          posterAsset,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                ),
                const SizedBox(height: 14),
              ],

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 13,
                  height: 1.48,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 14),

              // Date Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📅 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12.5,
                          color: Color(0xFF1E293B),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Date: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: date),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Location Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📍 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12.5,
                          color: Color(0xFF1E293B),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Location: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: location),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
