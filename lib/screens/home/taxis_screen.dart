import 'package:flutter/material.dart';
import '../../models/taxi.dart';
import 'view_taxi_screen.dart';

class TaxisScreen extends StatefulWidget {
  const TaxisScreen({super.key});

  @override
  State<TaxisScreen> createState() => _TaxisScreenState();
}

class _TaxisScreenState extends State<TaxisScreen> {
  String _selectedDistrict = "Dimapur / Chumoukedima";

  final List<String> _districts = [
    "Dimapur / Chumoukedima",
    "Kiphire",
    "Kohima",
    "Longleng",
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
    "Meluri",
  ];

  final List<Taxi> _taxis = [
    Taxi(
      id: "taxi_1",
      driverName: "Thejakilie Miasalhou",
      vehicleName: "Bolero BS6 - 4 Seater",
      vehicleType: "4 Seater",
      district: "Kohima",
      phone: "7085674965",
      rating: 4.8,
      price: "₹3,500 / day",
      servingDistricts: [
        "Dimapur / Chümoukedima",
        "Kohima",
        "Meluri",
        "Kiphire",
        "Longleng",
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
        "Zünheboto"
      ],
    ),
    Taxi(
      id: "taxi_2",
      driverName: "Reche Patrick Wetsah",
      vehicleName: "Bolero B6 - 4 Seater",
      vehicleType: "4 Seater",
      district: "Kohima",
      phone: "9862112233",
      rating: 4.7,
      price: "₹3,200 / day",
      servingDistricts: ["Dimapur / Chümoukedima", "Kohima", "Wokha", "Phek"],
    ),
    Taxi(
      id: "taxi_3",
      driverName: "Bizo Vero",
      vehicleName: "Kia Carens - 7 Seater",
      vehicleType: "7 Seater",
      district: "Dimapur",
      phone: "9436123456",
      rating: 4.9,
      price: "₹4,200 / day",
      servingDistricts: ["Dimapur / Chümoukedima", "Kohima", "Mokokchung"],
    ),
    Taxi(
      id: "taxi_4",
      driverName: "Samuel",
      vehicleName: "Tata Indigo - 4 Seater",
      vehicleType: "4 Seater",
      district: "Dimapur",
      phone: "8730889900",
      rating: 4.6,
      price: "₹2,600 / day",
      servingDistricts: ["Dimapur / Chümoukedima", "Kohima"],
    ),
    Taxi(
      id: "taxi_5",
      driverName: "Mhathung Tungoe",
      vehicleName: "Renault Kiger - 4 Seater",
      vehicleType: "4 Seater",
      district: "Dimapur",
      phone: "9862776655",
      rating: 4.8,
      price: "₹3,000 / day",
      servingDistricts: ["Dimapur / Chümoukedima", "Wokha", "Kohima"],
    ),
  ];

  void _showDistrictPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'Select District',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _districts.length,
                  itemBuilder: (context, idx) {
                    final d = _districts[idx];
                    final isSel = _selectedDistrict == d;
                    return ListTile(
                      title: Text(
                        d,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                          color: isSel ? const Color(0xFF20B08D) : const Color(0xFF1E293B),
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check, color: Color(0xFF20B08D))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedDistrict = d;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003848),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Deep Teal Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Taxis',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Taxis • Outstation Cabs',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                    children: [
                      Text(
                        'Find Taxis in ${_selectedDistrict.split('/').first.trim()}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Taxi list items
                      ..._taxis.map((taxi) => _buildTaxiItem(taxi)),
                    ],
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
    final isVan = taxi.vehicleName.toLowerCase().contains("7 seater") ||
        taxi.vehicleName.toLowerCase().contains("carens");
    final iconAsset = isVan ? 'assets/images/taxi_3d_van.png' : 'assets/images/taxi_3d_yellow.png';

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
