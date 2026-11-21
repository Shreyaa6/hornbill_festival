import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/custom_bottom_bar.dart';

class TripPlannersScreen extends StatefulWidget {
  final String tourTitle;

  const TripPlannersScreen({
    super.key,
    this.tourTitle = "Dzukou Valley Tours",
  });

  @override
  State<TripPlannersScreen> createState() => _TripPlannersScreenState();
}

class _TripPlannersScreenState extends State<TripPlannersScreen> {
  final List<Map<String, dynamic>> _operators = const [
    {
      "businessName": "Abode Venture",
      "address": "NagaBazar Colony, Kohima",
      "phoneNumber": "7005638258",
      "localAsset": "assets/images/logo_abode_venture.png",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2Fadobe_ventures.jpg?alt=media&token=5dba499d-436f-45ec-a734-c9db631b5a7c",
    },
    {
      "businessName": "Tribal Odyssey",
      "address": "Kohima, Kohima",
      "phoneNumber": "9862568055",
      "localAsset": "assets/images/logo_tribal_odyssey.png",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FTribalOdyssey_5206592.jpg?alt=media&token=3eec8465-b35a-49cf-9de1-bc4984c441b4",
    },
  ];

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header with Back button, Title & Subtitle
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Trip Planners',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tourTitle,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // White Rounded Body Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                      children: [
                        const Text(
                          'Find Tour Operators',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // List of Operators
                        ..._operators.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final op = entry.value;
                          final isLast = idx == _operators.length - 1;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  // Logo Avatar
                                  ClipOval(
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                        imageUrl: op["photo"] ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Image.asset(
                                          op["localAsset"] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: const Color(0xFFF1F5F9),
                                            child: const Icon(
                                              Icons.business_rounded,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (_, __, ___) =>
                                            Image.asset(
                                          op["localAsset"] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: const Color(0xFFF1F5F9),
                                            child: const Icon(
                                              Icons.business_rounded,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Name and Address
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          op["businessName"] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          op["address"] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 13,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Call Button
                                  GestureDetector(
                                    onTap: () =>
                                        _makeCall(op["phoneNumber"] ?? ''),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF20B08D)
                                              .withValues(alpha: 0.5),
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.02),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.phone_outlined,
                                        color: Color(0xFF20B08D),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLast)
                                const Divider(
                                  color: Color(0xFFF1F5F9),
                                  height: 32,
                                  thickness: 1,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation Bar
            CustomBottomBar(
              currentIndex: 0,
              onTap: (index) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
