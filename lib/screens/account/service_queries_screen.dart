import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firebase_service.dart';
import '../../data/mock_user.dart';
import '../../theme/app_theme.dart';

class ServiceQueriesScreen extends StatefulWidget {
  const ServiceQueriesScreen({super.key});

  @override
  State<ServiceQueriesScreen> createState() => _ServiceQueriesScreenState();
}

class _ServiceQueriesScreenState extends State<ServiceQueriesScreen> {
  // Date filter: 'Today' (default), 'Yesterday', 'All', or custom 'YYYY-MM-DD'
  String _selectedDateFilter = 'Today';
  String? _customDateString;

  // Service filter: 'all', 'hotel', 'taxi', 'cafe', 'tour_guide', 'tour_operator', 'stall'
  String _selectedServiceType = 'all';

  // Toggle provider specific vs all queries
  bool _filterByCurrentProvider = false;

  final Map<String, String> _serviceLabels = {
    'all': 'All Services',
    'hotel': 'Hotels',
    'taxi': 'Taxis',
    'cafe': 'Cafés',
    'tour_guide': 'Tour Guides',
    'tour_operator': 'Tour Operators',
    'stall': 'Kisama Stalls',
  };

  final Map<String, Color> _serviceColors = {
    'hotel': const Color(0xFF0284C7),
    'taxi': const Color(0xFFEAB308),
    'cafe': const Color(0xFFEA580C),
    'tour_guide': const Color(0xFF10B981),
    'tour_operator': const Color(0xFF8B5CF6),
    'stall': const Color(0xFFEC4899),
  };

  String _formatToday() {
    final now = DateTime.now();
    final y = now.year.toString();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final y = yesterday.year.toString();
    final m = yesterday.month.toString().padLeft(2, '0');
    final d = yesterday.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatReadableDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String get _dateFilterDisplayLabel {
    if (_selectedDateFilter == 'Today') {
      return 'Today (${_formatReadableDate(DateTime.now())})';
    } else if (_selectedDateFilter == 'Yesterday') {
      return 'Yesterday (${_formatReadableDate(DateTime.now().subtract(const Duration(days: 1)))})';
    } else if (_selectedDateFilter == 'Custom' && _customDateString != null) {
      final parsed = DateTime.tryParse(_customDateString!);
      return parsed != null ? _formatReadableDate(parsed) : _customDateString!;
    }
    return 'All Dates';
  }

  String? get _resolvedDateFilter {
    if (_selectedDateFilter == 'Today') return _formatToday();
    if (_selectedDateFilter == 'Yesterday') return _formatYesterday();
    if (_selectedDateFilter == 'Custom') return _customDateString;
    return null; // 'All'
  }

  Future<void> _showDateFilterSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF003848),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Filter by Date',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quick selector buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSheetPill(
                        label: 'Today',
                        isSelected: _selectedDateFilter == 'Today',
                        onTap: () {
                          setState(() {
                            _selectedDateFilter = 'Today';
                            _customDateString = null;
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildSheetPill(
                        label: 'Yesterday',
                        isSelected: _selectedDateFilter == 'Yesterday',
                        onTap: () {
                          setState(() {
                            _selectedDateFilter = 'Yesterday';
                            _customDateString = null;
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildSheetPill(
                        label: 'All Dates',
                        isSelected: _selectedDateFilter == 'All',
                        onTap: () {
                          setState(() {
                            _selectedDateFilter = 'All';
                            _customDateString = null;
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 6),

                // Embedded Calendar View inside bottom sheet
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF003848),
                      onPrimary: Colors.white,
                      onSurface: Color(0xFF1E293B),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _selectedDateFilter == 'Custom' && _customDateString != null
                        ? DateTime.tryParse(_customDateString!) ?? DateTime.now()
                        : (_selectedDateFilter == 'Yesterday'
                            ? DateTime.now().subtract(const Duration(days: 1))
                            : DateTime.now()),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                    onDateChanged: (picked) {
                      final y = picked.year.toString();
                      final m = picked.month.toString().padLeft(2, '0');
                      final d = picked.day.toString().padLeft(2, '0');
                      final pickedStr = '$y-$m-$d';
                      setState(() {
                        if (pickedStr == _formatToday()) {
                          _selectedDateFilter = 'Today';
                          _customDateString = null;
                        } else if (pickedStr == _formatYesterday()) {
                          _selectedDateFilter = 'Yesterday';
                          _customDateString = null;
                        } else {
                          _selectedDateFilter = 'Custom';
                          _customDateString = pickedStr;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003848) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF003848) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Future<void> _callCustomer(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number recorded for caller.')),
      );
      return;
    }

    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _logTestQuery() async {
    final now = DateTime.now();
    await FirebaseService().logServiceQuery(
      serviceType: 'hotel',
      serviceName: 'Hotel Japfü (Test Lead)',
      serviceId: 'H_TEST',
      providerId: MockUser().userId.isNotEmpty ? MockUser().userId : 'TEST_PROVIDER_01',
      providerPhone: '+919876543210',
      action: 'call',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test inquiry logged successfully!'),
          backgroundColor: Color(0xFF20B08D),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);
    final mockUser = MockUser();
    final bool hasProviderId = mockUser.isLoggedIn && mockUser.userId.isNotEmpty;

    final String? providerFilter = (_filterByCurrentProvider && hasProviderId)
        ? mockUser.userId
        : null;

    final String? serviceFilter =
        _selectedServiceType == 'all' ? null : _selectedServiceType;

    return Scaffold(
      backgroundColor: headerColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Inquiries',
                              style: AppTextStyles.headerTitle,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Provider & Manager Lead Logs',
                              style: AppTextStyles.headerSubtitle,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Add Test Lead',
                        icon: const Icon(Icons.add_circle_outline_rounded,
                            color: Colors.white),
                        onPressed: _logTestQuery,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Date Filter Dropdown (comes from bottom as dropdown sheet)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showDateFilterSheet,
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                size: 18,
                                color: Color(0xFF003848),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _dateFilterDisplayLabel,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Date Filter Selector Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill(
                          label: 'Today',
                          isSelected: _selectedDateFilter == 'Today',
                          onTap: () =>
                              setState(() {
                                _selectedDateFilter = 'Today';
                                _customDateString = null;
                              }),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterPill(
                          label: 'Yesterday',
                          isSelected: _selectedDateFilter == 'Yesterday',
                          onTap: () =>
                              setState(() {
                                _selectedDateFilter = 'Yesterday';
                                _customDateString = null;
                              }),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterPill(
                          label: 'All Dates',
                          isSelected: _selectedDateFilter == 'All',
                          onTap: () =>
                              setState(() {
                                _selectedDateFilter = 'All';
                                _customDateString = null;
                              }),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterPill(
                          label: _selectedDateFilter == 'Custom' &&
                                  _customDateString != null
                              ? _customDateString!
                              : 'Pick Date 📅',
                          isSelected: _selectedDateFilter == 'Custom',
                          onTap: _showDateFilterSheet,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Service Type Filter Row
            Container(
              color: headerColor,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _serviceLabels.entries.map((entry) {
                    final isSelected = _selectedServiceType == entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedServiceType = entry.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight:
                                  isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 12.5,
                              color: isSelected
                                  ? const Color(0xFF003848)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // White Rounded Body Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: FirebaseService().getQueriesStream(
                      providerId: providerFilter,
                      dateFilter: _resolvedDateFilter,
                      serviceType: serviceFilter,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      final queries = snapshot.data ?? [];

                      if (queries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_rounded,
                                size: 56,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No queries found',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _selectedDateFilter == 'All'
                                    ? 'No customer inquiries logged yet.'
                                    : 'No inquiries logged for $_selectedDateFilter.',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Test Lead'),
                                onPressed: _logTestQuery,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                        itemCount: queries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = queries[index];
                          return _buildQueryCard(item);
                        },
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

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 13,
            color: isSelected ? const Color(0xFF003848) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildQueryCard(Map<String, dynamic> item) {
    final userName = item['userName']?.toString() ?? 'Tourist Caller';
    final userPhone = item['userPhone']?.toString() ?? '';
    final serviceName = item['serviceName']?.toString() ?? 'Service';
    final serviceType = item['serviceType']?.toString() ?? 'service';
    final dateTime = item['dateTime']?.toString() ?? '';
    final badgeColor = _serviceColors[serviceType] ?? const Color(0xFF0284C7);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Service name & Service Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  serviceType.toUpperCase().replaceAll('_', ' '),
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Caller Details & Time
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateTime.isNotEmpty ? dateTime : 'Recent Call',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // 1-Tap "Call Back" Button
              if (userPhone.isNotEmpty)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20B08D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.phone_rounded, size: 16),
                  label: const Text(
                    'Call Back',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () => _callCustomer(userPhone),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
