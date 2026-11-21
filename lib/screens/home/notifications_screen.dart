import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
import '../../widgets/app_header_bar.dart';
import '../../widgets/dashed_border.dart';

class NotificationsScreen extends StatefulWidget {
  final bool embedded;
  final ValueChanged<int>? onSwitchTab;

  const NotificationsScreen({
    super.key,
    this.embedded = false,
    this.onSwitchTab,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _defaultNotifications = [
    {
      "title": "Advent Christmas Devotional Service - Hosts List",
      "date": "7th December, 2025",
      "isRead": false,
      "body":
          "The hosts list and order of service for the Advent Christmas Devotional gathering at Kisama Main Arena. All tribal representatives and visitors are cordially invited to participate in this evening of worship and fellowship.",
    },
    {
      "title": "Advent Christmas Devotional Service on 8th December",
      "date": "7th December, 2024",
      "isRead": true,
      "body":
          "Special Advent Christmas service to be held at Kisama Main Arena commencing at 4:30 PM. Festive carols, choir presentations by various church denominations, and prayer for peace in Nagaland.",
    },
    {
      "title": "Naga Wrestling Championship | 6th December, 10:00 AM",
      "date": "6th December, 2024",
      "isRead": false,
      "body":
          "The prestigious International & Tribal Naga Wrestling Championship will kick off at the Kisama Amphitheatre at 10:00 AM. Featuring top wrestlers from Angami, Chakhesang, Zeliang, and guest international competitors.",
    },
    {
      "title": "Artist list for Music Festival | Day 8 to 10",
      "date": "4th December, 2024",
      "isRead": false,
      "body":
          "Official line-up and stage schedule for the Hornbill Music Festival Days 8 to 10 featuring headlining rock bands, folk-fusion artists, and EDM acts at the Agri Expo and Kisama Arena stages.",
    },
    {
      "title": "Artist list for Music Festival | Day 4 to 7",
      "date": "4th December, 2024",
      "isRead": false,
      "body":
          "Schedule of live band performances, choir presentations, and acoustic folk sessions for Hornbill Music Festival Days 4 through 7.",
    },
    {
      "title": "Stone Pulling Ceremony | 4th December, 10:00 AM",
      "date": "3rd December, 2024",
      "isRead": false,
      "body":
          "The traditional stone pulling ceremony signifying triumph, unity, and communal feast will take place from Kisama Village Entry Gate to the Main Heritage Complex at 10:00 AM.",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showNoticeDetail(Map<String, dynamic> notice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                notice["title"] ?? '',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 13, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    notice["date"] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: AppColors.border),
              const SizedBox(height: 14),
              Text(
                notice["body"] ?? '',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseService().getNotifications(),
      builder: (context, snapshot) {
        List<Map<String, dynamic>> items;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final query = _searchController.text.trim().toLowerCase();
          final liveList = snapshot.data!.map((doc) => {
            "title": doc["title"]?.toString() ?? '',
            "date": doc["date"]?.toString() ?? '',
            "isRead": doc["isRead"] == true,
            "body": doc["body"]?.toString() ?? doc["title"]?.toString() ?? '',
          }).toList();
          items = query.isEmpty
              ? liveList
              : liveList.where((n) {
                  final title = (n["title"] ?? '').toString().toLowerCase();
                  final body = (n["body"] ?? '').toString().toLowerCase();
                  return title.contains(query) || body.contains(query);
                }).toList();
        } else {
          final query = _searchController.text.trim().toLowerCase();
          items = query.isEmpty
              ? _defaultNotifications
              : _defaultNotifications.where((n) {
                  final title = (n["title"] ?? '').toString().toLowerCase();
                  final body = (n["body"] ?? '').toString().toLowerCase();
                  return title.contains(query) || body.contains(query);
                }).toList();
        }

        Widget content = SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 120 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting + Notifications Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: mockUser,
                        builder: (context, _) {
                          final name = mockUser.isLoggedIn ? mockUser.name : "Test mk";
                          return Text(
                            'Hey $name 👋',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFF20B08D),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/user.png',
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF1E293B),
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Notification Cards List
              ...items.map((notice) {
                final isRead = notice["isRead"] == true;

                if (isRead) {
                  // Muted / Read Card
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showNoticeDetail(notice),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notice["title"] ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF94A3B8),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notice["date"] ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '?',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Active Unread Card with Mint Dashed Border
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showNoticeDetail(notice),
                    child: DashedBorder(
                      color: const Color(0xFF20B08D),
                      backgroundColor: const Color(0xFFE2FAF4),
                      borderRadius: 14,
                      strokeWidth: 1.2,
                      dashLength: 5,
                      dashGap: 3,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice["title"] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notice["date"] ?? '',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '?',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF20B08D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );

        if (widget.embedded) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: content,
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const AppHeaderBar(showBackButton: true),
                Expanded(child: content),
              ],
            ),
          ),
        );
      },
    );
  }
}
