import 'package:flutter/material.dart';
import '../../data/taxis_data.dart';
import '../../models/taxi.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'view_taxi_screen.dart';

class TaxisScreen extends StatefulWidget {
  const TaxisScreen({super.key});

  @override
  State<TaxisScreen> createState() => _TaxisScreenState();
}

class _TaxisScreenState extends State<TaxisScreen> {
  String _selectedDistrict = "Dimapur / Chümoukedima";

  final List<String> _districts = [
    "All Districts",
    "Dimapur / Chümoukedima",
    "Kiphire",
    "Kohima",
    "Longleng",
    "Meluri",
    "Mokokchung",
    "Mon",
    "Niuland",
    "Noklak",
    "Peren",
    "Phek",
    "Shamator",
    "Tseminyü",
    "Tuensang",
    "Wokha",
    "Zünheboto",
  ];

  void _showDistrictPicker() async {
    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Select District',
      items: _districts,
      selectedItem: _selectedDistrict,
      sortAlphabetically: true,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDistrict = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Deep Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Taxis',
                        style: AppTextStyles.headerTitle,
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Taxis • Outstation Cabs',
                        style: AppTextStyles.headerSubtitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // District Selector Pill
                  GestureDetector(
                    onTap: _showDistrictPicker,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDistrict,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirebaseService().getTaxis(),
                    builder: (context, snapshot) {
                      List<Taxi> allTaxis;
                      if (snapshot.hasData) {
                        allTaxis = snapshot.data!.map((data) {
                          return Taxi.fromFirestore(data, data['docId']?.toString() ?? '');
                        }).toList();
                      } else {
                        allTaxis = TaxisData.allTaxis;
                      }

                      final filteredTaxis = allTaxis.where((taxi) {
                        if (!taxi.isActive) return false;
                        return taxi.isServingDistrict(_selectedDistrict);
                      }).toList();

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                        children: [
                          Text(
                            _selectedDistrict == "All Districts"
                                ? 'All Available Taxis'
                                : 'Find Taxis in $_selectedDistrict',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(36.0),
                                child: CircularProgressIndicator(color: Color(0xFF20B08D)),
                              ),
                            )
                          else if (filteredTaxis.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_taxi_outlined,
                                      size: 56,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No taxis available in $_selectedDistrict',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...filteredTaxis.map((taxi) => _buildTaxiItem(taxi)),
                        ],
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

  Widget _buildTaxiItem(Taxi taxi) {
    final seaterDesc = '${taxi.vehicleType} ${taxi.vehicleName}'.toLowerCase();
    final is7Seater = seaterDesc.contains("7 seater") ||
        seaterDesc.contains("7-seater") ||
        seaterDesc.contains("7seater") ||
        seaterDesc.contains("carens") ||
        seaterDesc.contains("innova") ||
        seaterDesc.contains("traveller") ||
        seaterDesc.contains("7");
    final iconAsset =
        is7Seater ? 'assets/images/jeep.png' : 'assets/images/taxi.png';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewTaxiScreen(taxi: taxi),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              height: 44,
              width: 50,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                is7Seater
                    ? 'assets/images/taxi_3d_van.png'
                    : 'assets/images/taxi_3d_yellow.png',
                height: 44,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taxi.vehicleName,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 16.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Driver: ${taxi.driverName}',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF20B08D),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
