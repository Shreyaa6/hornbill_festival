import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCafeScreen extends StatelessWidget {
  final Map<String, dynamic> cafe;

  const ViewCafeScreen({super.key, required this.cafe});

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = cafe['name'] ?? cafe['cafeName'] ?? 'Axone kitchen';
    final location = cafe['location'] ?? cafe['address'] ?? 'CY Complex, Opp. Rengma Church , Nagaland';
    final phone = cafe['phone'] ?? cafe['phoneNumber'] ?? '6009516476';
    final photoAsset = cafe['photoAsset'] as String? ?? 'assets/images/cafe_axone_banner.png';
    final menuAsset = cafe['menuAsset'] as String? ?? 'assets/images/cafe_axone_menu.png';
    final photoUrl = cafe['photo'] as String?;
    final menuList = cafe['menu'] as List<dynamic>?;
    final menuUrl = (menuList != null && menuList.isNotEmpty) ? menuList.first.toString() : null;

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
                      child: photoUrl != null
                          ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                photoAsset,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              photoAsset,
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
                          spacing: 8,
                          runSpacing: 10,
                          children: cuisinesList.map((cuisine) {
                            final isNaga = cuisine == 'Naga Cuisines';
                            if (isNaga) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD2F5EC),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF20B08D),
                                  ),
                                ),
                                child: Text(
                                  cuisine,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00796B),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                cuisine,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Menu Heading
                        const Text(
                          'Menu',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Menu Image Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: menuUrl != null
                                ? Image.network(
                                    menuUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      menuAsset,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    menuAsset,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
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
