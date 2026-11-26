import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/firebase_service.dart';
import '../../widgets/cafe_image.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../theme/app_theme.dart';

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
  Stream<List<Map<String, dynamic>>>? _operatorStream;

  @override
  void initState() {
    super.initState();
    try {
      _operatorStream = FirebaseService().getTourOperators();
    } catch (_) {
      _operatorStream = null;
    }
  }
  static final List<Map<String, dynamic>> _fallbackOperators = [
    {
      "businessName": "Tribal Odyssey",
      "owner": "Veshehu Kezo",
      "address": "Kohima",
      "district": "Kohima",
      "phoneNumber": "9862568055",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2FTribalOdyssey_5206592.jpg?alt=media&token=3eec8465-b35a-49cf-9de1-bc4984c441b4",
      "localAsset": "assets/images/logo_tribal_odyssey.png",
      "isActive": true,
      "isDzukoTour": true,
      "isNagalandTour": true,
      "isNorthEastTour": true,
    },
    {
      "businessName": "Abode Venture",
      "owner": "Abode Team",
      "address": "NagaBazar Colony, Kohima",
      "district": "Kohima",
      "phoneNumber": "7005638258",
      "photo":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tour_operators%2Fadobe_ventures.jpg?alt=media&token=5dba499d-436f-45ec-a734-c9db631b5a7c",
      "localAsset": "assets/images/logo_abode_venture.png",
      "isActive": true,
      "isDzukoTour": true,
      "isNagalandTour": true,
      "isNorthEastTour": true,
    },
  ];

  Future<void> _makeCall(String phoneNumber, {Map<String, dynamic>? operator}) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.isEmpty) return;

    if (operator != null) {
      final name = operator["businessName"] ??
          operator["fullName"] ??
          operator["owner"] ??
          "Tour Operator";
      final opId =
          operator["operatorID"] ?? operator["docId"] ?? operator["id"];
      FirebaseService().logServiceQuery(
        serviceType: 'tour_operator',
        serviceName: name.toString(),
        serviceId:
            (operator["docId"] ?? operator["id"] ?? opId ?? "").toString(),
        providerId: operator["operatorID"]?.toString(),
        providerPhone: clean,
        district: operator["district"]?.toString(),
        action: 'call',
      );
    }

    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  bool _matchesTour(Map<String, dynamic> op) {
    final title = widget.tourTitle.toLowerCase();
    if (title.contains('dzuk') || title.contains('dzuko')) {
      if (op.containsKey('isDzukoTour')) {
        return op['isDzukoTour'] == true || op['isDzukoTour'] == 'true';
      }
      return true;
    }
    if (title.contains('nagaland')) {
      if (op.containsKey('isNagalandTour')) {
        return op['isNagalandTour'] == true || op['isNagalandTour'] == 'true';
      }
      return true;
    }
    if (title.contains('northeast') ||
        title.contains('north east') ||
        title.contains('north')) {
      if (op.containsKey('isNorthEastTour')) {
        return op['isNorthEastTour'] == true || op['isNorthEastTour'] == 'true';
      }
      return true;
    }
    return true;
  }

  Widget _buildOperatorLogo(Map<String, dynamic> op) {
    final photoUrl = (op["photo"] ?? op["document"] ?? '').toString().trim();
    final safeUrl = CafeImage.getWebSafeUrl(photoUrl) ?? photoUrl;
    final localAsset = (op["localAsset"] ?? '').toString().trim();

    return ClipOval(
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: safeUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: safeUrl,
                fit: BoxFit.cover,
                memCacheWidth: 160,
                fadeInDuration: const Duration(milliseconds: 100),
                placeholder: (_, __) => _buildFallbackIcon(op, localAsset),
                errorWidget: (_, __, ___) => _buildFallbackIcon(op, localAsset),
              )
            : _buildFallbackIcon(op, localAsset),
      ),
    );
  }

  Widget _buildFallbackIcon(Map<String, dynamic> op, String localAsset) {
    if (localAsset.isNotEmpty) {
      return Image.asset(
        localAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildLetterFallback(op),
      );
    }
    final name = (op['businessName'] ?? '').toString().toLowerCase();
    if (name.contains('tribal')) {
      return Image.asset(
        'assets/images/logo_tribal_odyssey.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildLetterFallback(op),
      );
    }
    if (name.contains('abode')) {
      return Image.asset(
        'assets/images/logo_abode_venture.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildLetterFallback(op),
      );
    }
    return _buildLetterFallback(op);
  }

  Widget _buildLetterFallback(Map<String, dynamic> op) {
    final name = (op['businessName'] ?? 'T').toString().trim();
    final char = name.isNotEmpty ? name.characters.first.toUpperCase() : 'T';
    return Container(
      color: const Color(0xFFE6F7F2),
      alignment: Alignment.center,
      child: Text(
        char,
        style: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF20B08D),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Title & Subtitle (flush left, no back arrow)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip Planners',
                        style: AppTextStyles.headerTitle,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.tourTitle,
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                ),

                // White Rounded Body Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _operatorStream,
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> sourceList;
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          sourceList = snapshot.data!;
                        } else {
                          sourceList = _fallbackOperators;
                        }

                        // Strict filter: Exclude any item where isActive is false
                        final activeOperators = sourceList.where((op) {
                          final active = op['isActive'] == true ||
                              op['isActive'] == 'true';
                          return active;
                        }).toList();

                        // Filter by tour type if applicable
                        final filtered = activeOperators
                            .where((op) => _matchesTour(op))
                            .toList();

                        return ListView(
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

                            if (filtered.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 48),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.travel_explore_rounded,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'No tour operators available right now',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ...filtered.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final op = entry.value;
                                final isLast = idx == filtered.length - 1;

                                final businessName = (op["businessName"] ?? '')
                                    .toString()
                                    .trim();
                                final owner =
                                    (op["owner"] ?? '').toString().trim();
                                final address =
                                    (op["address"] ?? '').toString().trim();
                                final district =
                                    (op["district"] ?? '').toString().trim();

                                String locationText = address;
                                if (district.isNotEmpty) {
                                  if (address.isEmpty) {
                                    locationText = district;
                                  } else if (!address
                                      .toLowerCase()
                                      .contains(district.toLowerCase())) {
                                    locationText = '$address, $district';
                                  }
                                }

                                final phone = (op["phoneNumber"] ??
                                        op["phone"] ??
                                        '')
                                    .toString()
                                    .trim();

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        // Logo Avatar
                                        _buildOperatorLogo(op),
                                        const SizedBox(width: 14),

                                        // Name, Owner and Address
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                businessName,
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF1E293B),
                                                ),
                                              ),
                                              if (owner.isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  owner,
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF20B08D),
                                                  ),
                                                ),
                                              ],
                                              if (locationText.isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  locationText,
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 12.5,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),

                                        // Call Button
                                        if (phone.isNotEmpty)
                                          GestureDetector(
                                            onTap: () => _makeCall(phone, operator: op),
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
                                                        .withValues(
                                                            alpha: 0.02),
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
                        );
                      },
                    ),
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
