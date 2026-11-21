import 'package:flutter/material.dart';
import '../../widgets/dashed_border.dart';

class DiscoverViewpointScreen extends StatefulWidget {
  const DiscoverViewpointScreen({super.key});

  @override
  State<DiscoverViewpointScreen> createState() => _DiscoverViewpointScreenState();
}

class _DiscoverViewpointScreenState extends State<DiscoverViewpointScreen> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _nearestTownController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedDistrict;
  final List<String> _photos = [];

  final List<String> _districts = [
    'Kohima',
    'Dimapur / Chumoukedima',
    'Kiphire',
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
    'Meluri',
  ];

  @override
  void dispose() {
    _placeNameController.dispose();
    _nearestTownController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

  void _handleUploadPhoto() {
    if (_photos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 photos allowed')),
      );
      return;
    }
    setState(() {
      _photos.add('assets/images/spot_totsu_cliff.png');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo ${_photos.length} added successfully!'),
        backgroundColor: const Color(0xFF20B08D),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleSubmit() {
    if (_placeNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a venue/place name')),
      );
      return;
    }
    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a district')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF20B08D), size: 28),
            SizedBox(width: 10),
            Text(
              'Submitted!',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w900,
                color: Color(0xFF003848),
              ),
            ),
          ],
        ),
        content: const Text(
          'Thank you for contributing to Nagaland Tourism! Your viewpoint will be reviewed and featured soon.',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF334155),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003848),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Lato', color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF003848),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Discover Viewpoint',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF003848),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Unveil Hidden Gems of Nagaland',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF20B08D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 38), // Balance spacing
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 100 + bottomInset),
                child: Column(
                  children: [
                    // Top Info Banner Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // Decorative soft mint circle on top-right
                          Positioned(
                            top: -24,
                            right: -24,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2FAF4).withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Explorer Initiative Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2FAF4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.explore_outlined,
                                        size: 14,
                                        color: Color(0xFF20B08D),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Explorer Initiative',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00796B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Title
                                const Text(
                                  'Found a New Viewpoint?',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF003848),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Subtitle
                                const Text(
                                  "Capture Nagaland's untouched beauty. Submit a viewpoint with photos, location details, and the story behind it.",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Main Form Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Venue Photos *
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Venue Photos *',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                '${_photos.length}/3 photos',
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF20B08D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Add upto 3 scenic photos showcasing the landscape and viewpoint.',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Upload Box and thumbnails
                          Row(
                            children: [
                              // Upload Box
                              GestureDetector(
                                onTap: _handleUploadPhoto,
                                child: DashedBorder(
                                  color: const Color(0xFF20B08D),
                                  backgroundColor: const Color(0xFFF0FDF9),
                                  borderRadius: 16,
                                  strokeWidth: 1.2,
                                  dashLength: 5,
                                  dashGap: 3.5,
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 24,
                                          color: Color(0xFF20B08D),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Upload Photo',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00796B),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${3 - _photos.length} slots left',
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 8.5,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Picked Photos Thumbnails
                              ..._photos.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final p = entry.value;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 12),
                                      width: 95,
                                      height: 95,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(p, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -6,
                                      right: -4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _photos.removeAt(idx);
                                          });
                                        },
                                        child: Container(
                                          height: 22,
                                          width: 22,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE11D48),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 2. Venue / Place Name *
                          const Text(
                            'Venue / Place Name *',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: TextField(
                              controller: _placeNameController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Mount Tiyi Ridge, Satoi Peak',
                                hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Color(0xFF64748B),
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 3. Nearest Town or Village *
                          const Text(
                            'Nearest Town or Village *',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: TextField(
                              controller: _nearestTownController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Viswema, Khonoma, Pfütsero',
                                hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                prefixIcon: Icon(
                                  Icons.apartment_rounded,
                                  color: Color(0xFF64748B),
                                  size: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 4. District*
                          const Text(
                            'District*',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _showDistrictPicker,
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.map_outlined,
                                    color: Color(0xFF64748B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _selectedDistrict ?? 'Select district',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        color: _selectedDistrict != null
                                            ? Colors.black
                                            : const Color(0xFF64748B),
                                        fontWeight: _selectedDistrict != null
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF64748B),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 5. State
                          const Text(
                            'State',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_outlined,
                                  color: Color(0xFF64748B),
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Nagaland',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2FAF4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.lock_rounded,
                                        size: 13,
                                        color: Color(0xFF20B08D),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Fixed',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00796B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 6. Description & Story / Legend (Optional)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Description & Story / Legend (Optional)',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Optional',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Share local folklore, the legend behind the name, trail tips, or best view timings.',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText:
                                    'Tell travelers what makes this viewpoint magical, any local folk story, or how to reach...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 13.5,
                                  color: Color(0xFF94A3B8),
                                  height: 1.4,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Submit Viewpoint Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _handleSubmit,
                              icon: const Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                'Submit Viewpoint',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003848),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
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
    );
  }
}
