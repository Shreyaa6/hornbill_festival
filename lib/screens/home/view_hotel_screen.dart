import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/hotel.dart';

class ViewHotelScreen extends StatelessWidget {
  final Hotel hotel;

  const ViewHotelScreen({super.key, required this.hotel});

  Future<void> _makeCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> _openMap() async {
    final query = Uri.encodeComponent('${hotel.name}, ${hotel.district}, Nagaland');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Image
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: hotel.image,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
                    ),
                    // Floating Back and Call Buttons
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black87,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => _makeCall(hotel.phone),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.phone_outlined,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Curved Details Card
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Address
                        Text(
                          hotel.address,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14.5,
                            color: Color(0xFF475569),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Self check-in
                        Row(
                          children: const [
                            Icon(Icons.vpn_key_outlined, size: 20, color: Color(0xFF1E293B)),
                            SizedBox(width: 12),
                            Text(
                              'Self check-in',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Navigate to location
                        GestureDetector(
                          onTap: _openMap,
                          child: Row(
                            children: const [
                              Icon(Icons.navigation_outlined, size: 20, color: Color(0xFF1E293B)),
                              SizedBox(width: 12),
                              Text(
                                'Navigate to location',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 20),

                        // Facilities Header
                        const Text(
                          'Facilities',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Facilities Icons Grid
                        Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: [
                            _buildFacilityItem(Icons.wifi_rounded, 'Free Wifi'),
                            _buildFacilityItem(Icons.restaurant_rounded, 'Fooding'),
                            _buildFacilityItem(Icons.pool_rounded, 'Pool'),
                            _buildFacilityItem(Icons.ac_unit_rounded, 'AC Rooms'),
                            _buildFacilityItem(Icons.bolt_rounded, '24x7\nPower'),
                            _buildFacilityItem(Icons.local_parking_rounded, 'Parking'),
                            _buildFacilityItem(Icons.kitchen_rounded, 'Fridge'),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Rooms Available Section
                        const Text(
                          'Rooms Available',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Room Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEBEBEB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  'assets/images/room_deluxe_double.png',
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Deluxe Double',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '₹7000.00',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16.5,
                                            color: Color(0xFF20B08D),
                                          ),
                                        ),
                                      ],
                                    ),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF20B08D),
                                        side: const BorderSide(color: Color(0xFF20B08D), width: 1.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      icon: const Icon(Icons.phone_outlined, size: 18),
                                      label: const Text(
                                        'Call',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () => _makeCall(hotel.phone),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

  Widget _buildFacilityItem(IconData icon, String label) {
    return SizedBox(
      width: 65,
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF20B08D), size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
