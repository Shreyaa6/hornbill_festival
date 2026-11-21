import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/taxi.dart';
import '../../widgets/app_header_bar.dart';

class ViewTaxiScreen extends StatelessWidget {
  final Taxi taxi;

  const ViewTaxiScreen({super.key, required this.taxi});

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    // All 16 Nagaland districts
    final allDistricts = [
      'Dimapur / Chümoukedima',
      'Meluri',
      'Kiphire',
      'Kohima',
      'Longleng',
      'Mokokchung',
      'Mon',
      'Niuland',
      'Noklak',
      'Peren',
      'Phek',
      'Shamator',
      'Tseminyü',
      'Tuensang',
      'Wokha',
      'Zünheboto',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeaderBar(showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: e.g. "Bolero BS6"
                    Text(
                      taxi.vehicleName,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Location / District: e.g. "Kohima, Nagaland , Nagaland"
                    Text(
                      '${taxi.district}, Nagaland , Nagaland',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone row
                    InkWell(
                      onTap: () => _makeCall(taxi.phone),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              taxi.phone,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Driver row
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 26,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          taxi.driverName,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    const SizedBox(height: 20),

                    // Section Heading: "Districts Serving"
                    const Text(
                      'Districts Serving',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Wrap of Districts
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: allDistricts.map((district) {
                        final isDimapur = district.contains('Dimapur');
                        final isKohima = district == 'Kohima';

                        if (isDimapur) {
                          // Mint filled badge
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
                              district,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00796B),
                              ),
                            ),
                          );
                        } else if (isKohima) {
                          // Mint bordered badge
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF20B08D),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              district,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF20B08D),
                              ),
                            ),
                          );
                        } else {
                          // Light gray badge
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
                              district,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
