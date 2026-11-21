import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/firebase_service.dart';

class HornbillProgramsScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const HornbillProgramsScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

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
                    'assets/images/hornbill_elder_banner.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),

                // White Rounded Body Sheet Overlapping the Banner
                Transform.translate(
                  offset: const Offset(0, -26),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                    ),
                    padding: EdgeInsets.fromLTRB(18, 22, 18, 120 + bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Subtitle
                        const Text(
                          'Programs & Contests',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 3),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: FirebaseService().getContests(),
                          builder: (context, snapshot) {
                            final events = snapshot.data ?? [];
                            final countText = events.isNotEmpty ? '${events.length} Events' : '46 Events';
                            return Text(
                              countText,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),

                        // Live Contests & Programs Stream from Firestore
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: FirebaseService().getContests(),
                          builder: (context, snapshot) {
                            final events = snapshot.data;
                            if (events != null && events.isNotEmpty) {
                              return Column(
                                children: events.map((ev) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 26),
                                    child: _buildEventCard(
                                      title: ev['title']?.toString() ?? 'Hornbill Event',
                                      posterAsset: ev['poster']?.toString(),
                                      description: ev['description']?.toString() ?? '',
                                      date: ev['date']?.toString() ?? '',
                                      location: ev['location']?.toString() ?? 'Kisama Heritage Village',
                                    ),
                                  );
                                }).toList(),
                              );
                            }

                            // Fallback default list
                            return Column(
                              children: [
                                _buildEventCard(
                                  title: 'Hornbill Music Festival',
                                  posterAsset: 'assets/images/poster_music_festival.png',
                                  description:
                                      'Hornbill Music Festival 2025\'s Busking Zone at Unity Plaza, Heritage Village Kisama, will feature emerging artists from all districts of Nagaland performing from 2nd to 9th December 2025, offering daily live music showcases that celebrate the state\'s rich and diverse musical talent.',
                                  date: '2nd - 9th December, 2025',
                                  location: 'Unity Plaza, Heritage Village - Kisama',
                                ),
                                const SizedBox(height: 26),
                                _buildEventCard(
                                  title: 'The Great Hornbill Run',
                                  posterAsset: 'assets/images/poster_hornbill_run.png',
                                  description:
                                      'The 5th Edition Nagaland 10K \'The Great Hornbill Run,\' on 5 December 2025 at the Regional Centre for Sporting Excellence (RCSE), Sovima, Chumoukedima, featuring competitive runs for Men & Women categories with exciting cash awards.',
                                  date: '5th December, 2025',
                                  location:
                                      'Regional Centre for Sporting Excellence (RCSE), Sovima, Chumoukedima',
                                ),
                                const SizedBox(height: 26),
                                _buildEventCard(
                                  title: 'Hornbill International Photo Fest',
                                  posterAsset: null,
                                  description:
                                      'Capturing the vibrant expressions, indigenous regalia, and living folklore of all 18 recognized tribes through the lens of acclaimed national and international documentary photographers.',
                                  date: '1st - 10th December, 2025',
                                  location: 'World War II Museum Complex, Kisama',
                                ),
                                const SizedBox(height: 26),
                                _buildEventCard(
                                  title: 'Naga Chef Competition - Season 11',
                                  posterAsset: null,
                                  description:
                                      'The premier indigenous culinary championship of Northeast India, celebrating ancestral flavors, smoked meats, wild aromatic herbs, and master culinary techniques.',
                                  date: '1st - 9th December, 2025',
                                  location: 'Chef Arena, Kisama Heritage Village',
                                ),
                              ],
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
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    String? posterAsset,
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
                          placeholder: (_, __) => Container(
                            height: 180,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, __, ___) => const SizedBox(),
                        )
                      : Image.asset(
                          posterAsset,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
