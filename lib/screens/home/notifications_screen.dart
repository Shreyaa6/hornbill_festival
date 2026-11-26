import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/firebase_service.dart';
import '../../widgets/dashed_border.dart';

DateTime? parseNotificationDate(dynamic rawDate) {
  if (rawDate == null) return null;
  if (rawDate is DateTime) return rawDate;

  // Handle Firestore Timestamp or object with toDate()
  try {
    final dynamic d = rawDate;
    if (d.toDate != null && d.toDate is Function) {
      return d.toDate() as DateTime;
    }
  } catch (_) {}

  if (rawDate is int) {
    return DateTime.fromMillisecondsSinceEpoch(rawDate);
  }

  final str = rawDate.toString().trim();
  if (str.isEmpty) return null;

  final iso = DateTime.tryParse(str);
  if (iso != null) return iso;

  // Clean ordinal suffixes: 1st, 2nd, 3rd, 4th -> 1, 2, 3, 4
  final cleaned = str.replaceAllMapped(
    RegExp(r'(\d+)(st|nd|rd|th)', caseSensitive: false),
    (m) => m.group(1)!,
  );

  const months = {
    'jan': 1, 'january': 1,
    'feb': 2, 'february': 2,
    'mar': 3, 'march': 3,
    'apr': 4, 'april': 4,
    'may': 5,
    'jun': 6, 'june': 6,
    'jul': 7, 'july': 7,
    'aug': 8, 'august': 8,
    'sep': 9, 'september': 9,
    'oct': 10, 'october': 10,
    'nov': 11, 'november': 11,
    'dec': 12, 'december': 12,
  };

  // Pattern 1: Day Month Year (e.g. "7 December, 2026" or "7 Dec 2026")
  final matchDayMonthYear = RegExp(
    r'(\d{1,2})[\s,\-]+([a-zA-Z]+)[\s,\-]+(\d{4})',
  ).firstMatch(cleaned);

  if (matchDayMonthYear != null) {
    final day = int.tryParse(matchDayMonthYear.group(1)!);
    final monthStr = matchDayMonthYear.group(2)!.toLowerCase();
    final year = int.tryParse(matchDayMonthYear.group(3)!);
    final month = months[monthStr];
    if (day != null && year != null && month != null) {
      return DateTime(year, month, day);
    }
  }

  // Pattern 2: Month Day Year (e.g. "December 7, 2026" or "Dec 7 2026")
  final matchMonthDayYear = RegExp(
    r'([a-zA-Z]+)[\s,\-]+(\d{1,2})[\s,\-]+(\d{4})',
  ).firstMatch(cleaned);

  if (matchMonthDayYear != null) {
    final monthStr = matchMonthDayYear.group(1)!.toLowerCase();
    final day = int.tryParse(matchMonthDayYear.group(2)!);
    final year = int.tryParse(matchMonthDayYear.group(3)!);
    final month = months[monthStr];
    if (day != null && year != null && month != null) {
      return DateTime(year, month, day);
    }
  }

  // Pattern 3: YYYY/MM/DD or DD/MM/YYYY
  final matchSlash = RegExp(
    r'^(\d{1,4})[\/\-](\d{1,2})[\/\-](\d{1,4})$',
  ).firstMatch(cleaned);
  if (matchSlash != null) {
    final p1 = int.tryParse(matchSlash.group(1)!);
    final p2 = int.tryParse(matchSlash.group(2)!);
    final p3 = int.tryParse(matchSlash.group(3)!);
    if (p1 != null && p2 != null && p3 != null) {
      if (p1 > 1000) {
        return DateTime(p1, p2, p3);
      } else if (p3 > 1000) {
        return DateTime(p3, p2, p1);
      }
    }
  }

  return null;
}

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
      "date": "7th December, 2026",
      "isRead": false,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
      "body":
          "The hosts list and order of service for the Advent Christmas Devotional gathering at Kisama Main Arena. All tribal representatives and visitors are cordially invited to participate in this evening of worship and fellowship.",
    },
    {
      "title": "Advent Christmas Devotional Service on 8th December",
      "date": "7th December, 2024",
      "isRead": true,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
      "body":
          "Special Advent Christmas service to be held at Kisama Main Arena commencing at 4:30 PM. Festive carols, choir presentations by various church denominations, and prayer for peace in Nagaland.",
    },
    {
      "title": "Naga Wrestling Championship | 6th December, 10:00 AM",
      "date": "6th December, 2024",
      "isRead": false,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
      "body":
          "The prestigious International & Tribal Naga Wrestling Championship will kick off at the Kisama Amphitheatre at 10:00 AM. Featuring top wrestlers from Angami, Chakhesang, Zeliang, and guest international competitors.",
    },
    {
      "title": "Artist list for Music Festival | Day 8 to 10",
      "date": "4th December, 2024",
      "isRead": false,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
      "body":
          "Official line-up and stage schedule for the Hornbill Music Festival Days 8 to 10 featuring headlining rock bands, folk-fusion artists, and EDM acts at the Agri Expo and Kisama Arena stages.",
    },
    {
      "title": "Artist list for Music Festival | Day 4 to 7",
      "date": "4th December, 2024",
      "isRead": false,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
      "body":
          "Schedule of live band performances, choir presentations, and acoustic folk sessions for Hornbill Music Festival Days 4 through 7.",
    },
    {
      "title": "Stone Pulling Ceremony | 4th December, 10:00 AM",
      "date": "3rd December, 2024",
      "isRead": false,
      "file":
          "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/circulars%2FWhatsApp%20Image%202024-12-03%20at%2010.15.27%20PM.jpeg?alt=media&token=11acc0b4-be29-405d-ba60-96f5a242476e",
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
    setState(() {
      notice["isRead"] = true;
    });
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

  Future<void> _handleNotificationTap(Map<String, dynamic> notice) async {
    setState(() {
      notice["isRead"] = true;
    });

    final fileUrl = (notice["file"] ?? notice["url"] ?? notice["link"] ?? '').toString().trim();
    if (fileUrl.isNotEmpty) {
      final uri = Uri.tryParse(fileUrl);
      if (uri != null && uri.hasScheme) {
        try {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (!launched) {
            await launchUrl(uri);
          }
          return;
        } catch (e) {
          debugPrint('Error launching notification url: $e');
        }
      }
    }

    _showNoticeDetail(notice);
  }

  bool _matchesQuery(Map<String, dynamic> item, String query) {
    if (query.isEmpty) return true;
    final terms = query.toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    final title = (item["title"] ?? '').toString().toLowerCase();
    final body = (item["body"] ?? '').toString().toLowerCase();
    final date = (item["date"] ?? '').toString().toLowerCase();
    final combined = '$title $body $date';
    return terms.every((term) => combined.contains(term));
  }

  Widget _buildNotificationItem(Map<String, dynamic> notice) {
    final isRead = notice["isRead"] == true;
    final title = (notice["title"] ?? '').toString();
    final date = (notice["date"] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleNotificationTap(notice),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? const Color(0xFFE5E7EB)
                  : const Color(0xFF20B08D).withValues(alpha: 0.35),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14.5,
                        fontWeight: isRead ? FontWeight.w700 : FontWeight.w900,
                        color: isRead
                            ? const Color(0xFF64748B)
                            : const Color(0xFF0F172A),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.keyboard_double_arrow_right_rounded,
                size: 22,
                color: isRead
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF20B08D),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFF003848);
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseService().getNotifications(),
      builder: (context, snapshot) {
        final query = _searchController.text.trim();
        List<Map<String, dynamic>> rawList;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          rawList = snapshot.data!.map((doc) => {
            "title": doc["title"]?.toString() ?? '',
            "date": doc["date"]?.toString() ?? '',
            "isRead": doc["isRead"] == true,
            "body": doc["body"]?.toString() ?? doc["title"]?.toString() ?? '',
            "file": doc["file"]?.toString() ?? doc["url"]?.toString() ?? doc["link"]?.toString() ?? '',
            "rawDate": doc["rawDate"] ?? doc["date_created"] ?? doc["date"],
          }).toList();
        } else {
          rawList = _defaultNotifications
              .map((doc) => Map<String, dynamic>.from(doc))
              .toList();
        }

        // Sort in date order: most recent first (descending)
        rawList.sort((a, b) {
          final dtA = parseNotificationDate(a["rawDate"] ?? a["date"]);
          final dtB = parseNotificationDate(b["rawDate"] ?? b["date"]);
          if (dtA != null && dtB != null) {
            final cmp = dtB.compareTo(dtA);
            if (cmp != 0) return cmp;
          } else if (dtA != null) {
            return -1; // Items with valid dates come before unknown dates
          } else if (dtB != null) {
            return 1;
          }
          return 0;
        });

        final items = rawList.where((n) => _matchesQuery(n, query)).toList();

        return Scaffold(
          backgroundColor: headerColor,
          body: SafeArea(
            bottom: true,
            child: Column(
              children: [
                // Deep Teal Top Header (matches TaxisScreen style)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: AppTextStyles.headerTitle,
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Updates • Circulars • Alerts',
                            style: AppTextStyles.headerSubtitle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Pill (matches TaxisScreen selector pill)
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFF1E293B),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search notifications...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14.5,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // White Rounded Body Sheet (exactly like TaxisScreen)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(16, 22, 16, 120 + bottomInset),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Updates',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              if (items.isNotEmpty)
                                Text(
                                  '${items.length} ${items.length == 1 ? 'Notice' : 'Notices'}',
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Notification Cards List or Empty Search Result
                          if (items.isEmpty)
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 48, bottom: 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF1F5F9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.search_off_rounded,
                                        size: 36,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No notifications found',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    if (query.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'No results matching "$query"',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )
                          else
                            ...items.map(_buildNotificationItem),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
