import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/hotel.dart';
import '../../models/hotel_room.dart';
import '../../data/rooms_data.dart';
import '../../services/firebase_service.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/cafe_image.dart';

class ViewHotelScreen extends StatelessWidget {
  final Hotel hotel;

  const ViewHotelScreen({super.key, required this.hotel});

  Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.isEmpty) return;

    // Log query to Firestore for the hotel owner
    FirebaseService().logServiceQuery(
      serviceType: 'hotel',
      serviceName: hotel.name,
      serviceId: hotel.id,
      providerId: hotel.hotelID?.isNotEmpty == true ? hotel.hotelID : null,
      providerPhone: clean,
      district: hotel.district,
      action: 'call',
    );

    final uri = Uri.parse('tel:$clean');
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $uri');
    }
  }

  Future<void> _openMap() async {
    final gmapsUrl = hotel.gmaps?.trim();
    if (gmapsUrl != null && gmapsUrl.isNotEmpty) {
      final uri = Uri.parse(gmapsUrl);
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
    }
    final query = Uri.encodeComponent('${hotel.name}, ${hotel.district}, Nagaland');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch maps');
    }
  }

  Widget _buildHeroImage() {
    final assetPath = 'assets/images/hotels/${hotel.id}.jpg';
    return Image.asset(
      assetPath,
      height: 290,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        final photoUrl = (hotel.photoUrl != null && hotel.photoUrl!.isNotEmpty)
            ? hotel.photoUrl!
            : (hotel.image.startsWith('http') ? hotel.image : '');

        if (photoUrl.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: photoUrl,
            height: 290,
            width: double.infinity,
            fit: BoxFit.cover,
            memCacheWidth: 800,
            placeholder: (_, __) => _errorHeroPlaceholder(),
            errorWidget: (_, __, ___) => _errorHeroPlaceholder(),
          );
        }

        final fallbackAsset = hotel.image.startsWith('assets/') ? hotel.image : '';
        if (fallbackAsset.isNotEmpty) {
          return Image.asset(
            fallbackAsset,
            height: 290,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _errorHeroPlaceholder(),
          );
        }

        return _errorHeroPlaceholder();
      },
    );
  }

  Widget _errorHeroPlaceholder() {
    return Container(
      height: 290,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(Icons.hotel_rounded, color: Color(0xFF94A3B8), size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressText = hotel.address.isNotEmpty
        ? (hotel.district.isNotEmpty &&
                !hotel.address.toLowerCase().contains(hotel.district.toLowerCase())
            ? '${hotel.address} - ${hotel.district}'
            : hotel.address)
        : (hotel.district.isNotEmpty ? hotel.district : 'Nagaland');

    // Build list of active facilities based on Firestore booleans
    final facilitiesList = <Map<String, dynamic>>[];
    if (hotel.isWifi) {
      facilitiesList.add({'name': 'Free Wifi', 'icon': Icons.wifi_rounded});
    }
    if (hotel.isFooding) {
      facilitiesList.add({'name': 'Fooding', 'icon': Icons.flatware_rounded});
    }
    if (hotel.isPowerBackup) {
      facilitiesList.add({'name': '24x7\nPower', 'icon': Icons.offline_bolt_outlined});
    }
    if (hotel.isParking) {
      facilitiesList.add({'name': 'Parking', 'icon': Icons.directions_car_outlined});
    }
    if (hotel.isFridge) {
      facilitiesList.add({'name': 'Fridge', 'icon': Icons.kitchen_outlined});
    }
    if (hotel.isAC) {
      facilitiesList.add({'name': 'AC', 'icon': Icons.ac_unit_rounded});
    }
    if (hotel.isSwimming) {
      facilitiesList.add({'name': 'Pool', 'icon': Icons.pool_rounded});
    }

    // Fallback if none of the booleans are true but hotel has facilities list string
    if (facilitiesList.isEmpty && hotel.facilities.isNotEmpty) {
      for (final f in hotel.facilities) {
        final lower = f.toLowerCase();
        IconData icon = Icons.check_circle_outline_rounded;
        if (lower.contains('wifi')) {
          icon = Icons.wifi_rounded;
        } else if (lower.contains('food') || lower.contains('restaurant')) {
          icon = Icons.flatware_rounded;
        } else if (lower.contains('power') || lower.contains('backup')) {
          icon = Icons.offline_bolt_outlined;
        } else if (lower.contains('park')) {
          icon = Icons.directions_car_outlined;
        } else if (lower.contains('fridge')) {
          icon = Icons.kitchen_outlined;
        } else if (lower.contains('ac') || lower.contains('air')) {
          icon = Icons.ac_unit_rounded;
        } else if (lower.contains('pool') || lower.contains('swim')) {
          icon = Icons.pool_rounded;
        }
        facilitiesList.add({'name': f, 'icon': icon});
      }
    }

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
                    _buildHeroImage(),
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
                          addressText,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14.5,
                            color: Color(0xFF475569),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Self check-in
                        const Row(
                          children: [
                            Icon(Icons.key_rounded, size: 20, color: Color(0xFF1E293B)),
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
                          child: const Row(
                            children: [
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

                        if (facilitiesList.isNotEmpty) ...[
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
                            spacing: 16,
                            runSpacing: 18,
                            children: facilitiesList.map((f) {
                              return SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                    Icon(f['icon'] as IconData,
                                        color: const Color(0xFF20B08D), size: 28),
                                    const SizedBox(height: 6),
                                    Text(
                                      f['name'] as String,
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
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // Rooms Available Section Header
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

                        // Rooms List Stream with initialData for 0ms instant display
                        StreamBuilder<List<HotelRoom>>(
                          initialData: RoomsData.getRoomsForHotel(
                            hotelDocId: hotel.id,
                            hotelID: hotel.hotelID,
                          ),
                          stream: FirebaseService().getHotelRooms(
                            hotelDocId: hotel.id,
                            hotelID: hotel.hotelID,
                          ),
                          builder: (context, snapshot) {
                            final rooms = snapshot.data ?? [];
                            if (rooms.isEmpty) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 80,
                                  child: Center(
                                    child: CircularProgressIndicator(color: Color(0xFF20B08D)),
                                  ),
                                );
                              }
                              return _buildNoRoomsCard(hotel);
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: rooms.length,
                              itemBuilder: (context, index) {
                                return _RoomCard(
                                  room: rooms[index],
                                  onCall: () => _makeCall(hotel.phone),
                                );
                              },
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

          // Custom Bottom Navigation Bar
          CustomBottomBar(
            currentIndex: 0,
            onTap: (index) {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoRoomsCard(Hotel hotel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFD4FAF1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.meeting_room_outlined,
              color: Color(0xFF20B08D),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No rooms currently listed online',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Contact the property directly for live room availability, custom booking, and seasonal rates.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF20B08D), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            ),
            icon: const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF20B08D)),
            label: Text(
              hotel.phone.isNotEmpty ? 'Call ${hotel.phone}' : 'Call Property',
              style: const TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Color(0xFF20B08D),
              ),
            ),
            onPressed: () => _makeCall(hotel.phone),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final HotelRoom room;
  final VoidCallback onCall;

  const _RoomCard({
    required this.room,
    required this.onCall,
  });

  Widget _buildRoomImage() {
    if (room.images.isNotEmpty) {
      final rawUrl = room.images.first;
      return CachedNetworkImage(
        imageUrl: rawUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        memCacheWidth: 600,
        placeholder: (_, __) => Container(
          height: 180,
          color: const Color(0xFFF1F5F9),
        ),
        errorWidget: (_, __, ___) => Image.asset(
          'assets/images/room_deluxe_double.png',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/room_deluxe_double.png',
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          _buildRoomImage(),

          // Room Details & Outline Call Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${room.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF20B08D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF20B08D), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  icon: const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF20B08D)),
                  label: const Text(
                    'Call',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF20B08D),
                    ),
                  ),
                  onPressed: onCall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
