import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/dashed_border.dart';
import '../../services/firebase_service.dart';
import '../../data/mock_user.dart';

class ContestItem {
  final String id;
  final String authorName;
  final String photoAsset;
  final String? fullPhotoAsset;
  int votes;
  final String day;
  bool isVoted;

  ContestItem({
    required this.id,
    required this.authorName,
    required this.photoAsset,
    this.fullPhotoAsset,
    required this.votes,
    required this.day,
    this.isVoted = false,
  });
}

class PhotoContestScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const PhotoContestScreen({super.key, this.onBack});

  @override
  State<PhotoContestScreen> createState() => PhotoContestScreenState();
}

class PhotoContestScreenState extends State<PhotoContestScreen> {
  String _selectedDay = "All Days";
  bool _showToast = false;
  Timer? _toastTimer;
  ContestItem? _previewItem;
  bool _showShareModal = false;

  bool handleBack() {
    if (_previewItem != null) {
      setState(() => _previewItem = null);
      return true;
    }
    if (_showShareModal) {
      setState(() => _showShareModal = false);
      return true;
    }
    return false;
  }

  final List<ContestItem> _items = [
    ContestItem(
      id: '1',
      authorName: 'Tepuduho Benjami...',
      photoAsset: 'assets/images/contest_thumb_1.png',
      votes: 137,
      day: '08',
      isVoted: true, // Matches Screenshot 1 where first item is Voted
    ),
    ContestItem(
      id: '2',
      authorName: 'Tepuduho Benjami...',
      photoAsset: 'assets/images/contest_thumb_2.png',
      fullPhotoAsset: 'assets/images/contest_photo_warrior_full.png',
      votes: 121,
      day: '08',
      isVoted: false,
    ),
    ContestItem(
      id: '3',
      authorName: 'mountain Tour An...',
      photoAsset: 'assets/images/contest_thumb_3.png',
      votes: 105,
      day: '03',
      isVoted: false,
    ),
    ContestItem(
      id: '4',
      authorName: 'Tepuduho Benjami...',
      photoAsset: 'assets/images/contest_thumb_4.png',
      votes: 97,
      day: '08',
      isVoted: false,
    ),
    ContestItem(
      id: '5',
      authorName: 'TakeOffpongenex',
      photoAsset: 'assets/images/contest_thumb_5.png',
      votes: 42,
      day: '29',
      isVoted: false,
    ),
    ContestItem(
      id: '6',
      authorName: 'Sumesh P Nair',
      photoAsset: 'assets/images/contest_thumb_6.png',
      votes: 42,
      day: '03',
      isVoted: false,
    ),
    ContestItem(
      id: '7',
      authorName: 'Tepuduho Benjami...',
      photoAsset: 'assets/images/contest_thumb_7.png',
      votes: 37,
      day: '08',
      isVoted: false,
    ),
    ContestItem(
      id: '8',
      authorName: 'TakeOffpongenex',
      photoAsset: 'assets/images/contest_thumb_8.png',
      votes: 30,
      day: '01',
      isVoted: false,
    ),
    ContestItem(
      id: '9',
      authorName: 'Lens Sangs',
      photoAsset: 'assets/images/contest_thumb_9.png',
      votes: 22,
      day: '30',
      isVoted: false,
    ),
    ContestItem(
      id: '10',
      authorName: 'TakeOffpongenex',
      photoAsset: 'assets/images/contest_thumb_10.png',
      votes: 14,
      day: '02',
      isVoted: false,
    ),
    ContestItem(
      id: '11',
      authorName: 'TakeOffpongenex',
      photoAsset: 'assets/images/contest_thumb_11.png',
      votes: 12,
      day: '02',
      isVoted: false,
    ),
    ContestItem(
      id: '12',
      authorName: 'TakeOffpongenex',
      photoAsset: 'assets/images/contest_thumb_12.png',
      votes: 11,
      day: '02',
      isVoted: false,
    ),
  ];

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _handleVote(ContestItem item) {
    setState(() {
      if (item.isVoted) {
        item.isVoted = false;
        item.votes = (item.votes > 0) ? item.votes - 1 : 0;
      } else {
        item.isVoted = true;
        item.votes += 1;
        _showToast = true;
      }
    });

    if (item.isVoted) {
      final user = MockUser();
      final userId = user.userId.isNotEmpty
          ? user.userId
          : (user.email.isNotEmpty ? user.email : 'guest_user');
      FirebaseService().castVote(
        userId: userId,
        submissionDocId: item.id,
      );

      _toastTimer?.cancel();
      _toastTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            _showToast = false;
          });
        }
      });
    }
  }

  void _showDayFilterSheet() {
    final days = [
      'All Days',
      'Day 1 - 1st Dec',
      'Day 2 - 2nd Dec',
      'Day 3 - 3rd Dec',
      'Day 4 - 4th Dec',
      'Day 5 - 5th Dec',
      'Day 6 - 6th Dec',
      'Day 7 - 7th Dec',
      'Day 8 - 8th Dec',
      'Day 9 - 9th Dec',
      'Day 10 - 10th Dec',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filter by Day',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (_, index) {
                    final day = days[index];
                    return ListTile(
                      title: Text(day, style: const TextStyle(fontFamily: 'Lato')),
                      trailing: _selectedDay == day
                          ? const Icon(Icons.check, color: Color(0xFF20B08D))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final double bottomMargin = bottomInset > 0 ? bottomInset + 10 : 16;
    final double headerHeight = screenWidth * (332.0 / 524.0);

    return PopScope(
      canPop: _previewItem == null && !_showShareModal,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_previewItem != null) {
            setState(() => _previewItem = null);
          } else if (_showShareModal) {
            setState(() => _showShareModal = false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 0, 0, bottomMargin + 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Hero Mountain Header
                  SizedBox(
                    height: topInset + headerHeight,
                    width: screenWidth,
                    child: Stack(
                      children: [
                        // Sky fill extending behind status bar
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: topInset + 10,
                          child: Container(
                            color: const Color(0xFF38474B),
                          ),
                        ),

                        // Header Image matching aspect ratio
                        Positioned(
                          top: topInset,
                          left: 0,
                          right: 0,
                          height: headerHeight,
                          child: Image.asset(
                            'assets/images/contest_header_bg.png',
                            width: screenWidth,
                            height: headerHeight,
                            fit: BoxFit.fill,
                          ),
                        ),

                        // Back Button `<`
                        Positioned(
                          top: topInset + 8,
                          left: 14,
                          child: GestureDetector(
                            onTap: widget.onBack ??
                                () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),

                        // All Days Filter Pill Tap Region
                        Positioned(
                          top: topInset + (237.0 / 332.0) * headerHeight,
                          left: (50.0 / 524.0) * screenWidth,
                          right: (50.0 / 524.0) * screenWidth,
                          height: (60.0 / 332.0) * headerHeight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _showDayFilterSheet,
                            child: _selectedDay == 'All Days'
                                ? const SizedBox()
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/tent_clean_icon.png',
                                              height: 20,
                                              width: 20,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              _selectedDay,
                                              style: const TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                          ],
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Warning Notice Banner (Dashed Yellow Border)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DashedBorder(
                      color: const Color(0xFFF3C762),
                      backgroundColor: const Color(0xFFFFFDF1),
                      borderRadius: 12.0,
                      dashLength: 4.5,
                      dashGap: 3.5,
                      strokeWidth: 1.2,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: const Center(
                        child: Text(
                          'AI Generated Photos and irrelevant Photos will be\ndisqualified',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD69420),
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2-Column Grid of Photos (Live Firestore Sync)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<Set<String>>(
                      stream: FirebaseService().getUserVotes(
                        MockUser().userId.isNotEmpty
                            ? MockUser().userId
                            : (MockUser().email.isNotEmpty ? MockUser().email : 'guest_user'),
                      ),
                      builder: (context, voteSnapshot) {
                        final userVotedSet = voteSnapshot.data ?? {};
                        return StreamBuilder<List<Map<String, dynamic>>>(
                          stream: FirebaseService().getSubmissions(dayFilter: _selectedDay),
                          builder: (context, subSnapshot) {
                            final docs = subSnapshot.data;
                            List<ContestItem> displayItems;
                            if (docs != null && docs.isNotEmpty) {
                              displayItems = docs.map((doc) {
                                final docId = doc['docId']?.toString() ?? '';
                                final photoUrl = doc['photoUrl']?.toString() ?? '';
                                final name = doc['fullName']?.toString() ?? 'Photographer';
                                final votes = (doc['votes'] as num?)?.toInt() ?? 0;
                                final localDate = doc['localDateString']?.toString() ?? '';
                                final day = localDate.contains('-')
                                    ? localDate.split('-').last
                                    : '08';
                                return ContestItem(
                                  id: docId,
                                  authorName: name,
                                  photoAsset: photoUrl,
                                  fullPhotoAsset: photoUrl,
                                  votes: votes,
                                  day: day,
                                  isVoted: userVotedSet.contains(docId),
                                );
                              }).toList();
                            } else {
                              displayItems = _items;
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.71,
                              ),
                              itemCount: displayItems.length,
                              itemBuilder: (context, index) {
                                final item = displayItems[index];
                                return _buildCard(item);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Floating Toast: "🎉 Vote Counted"
            if (_showToast)
              Positioned(
                left: 16,
                right: 16,
                bottom: bottomMargin + 67 + 14,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showToast ? 1.0 : 0.0,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0FAF3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF67DFBE), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text(
                          'Vote Counted',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF13A27D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Floating Action Button `+`
            if (!_showToast)
              Positioned(
                right: 18,
                bottom: bottomMargin + 67 + 14,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showShareModal = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF073147),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

            // Screen 2: Full Photo Preview Overlay
            if (_previewItem != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _previewItem = null;
                    });
                  },
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.78),
                    alignment: Alignment.center,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, bottomMargin + 72),
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: (_previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset).startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: _previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    placeholder: (context, url) => Container(
                                      color: Colors.black26,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF13A27D),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      'assets/images/contest_photo_warrior_full.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : Image.asset(
                                    _previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Screen 4: Share Your Moment Modal Overlay
            if (_showShareModal)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _showShareModal = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.65),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {}, // Prevent tap inside dialog from dismissing modal
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/tent_clean_icon.png',
                              height: 64,
                              width: 64,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Share Your Moment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'December 1 - 10, 2025 • Hornbill\nFestival',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Choose Photo Button (Teal)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showShareModal = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Photo submitted for contest review!'),
                                      backgroundColor: Color(0xFF20B08D),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF20B08D),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('📸', style: TextStyle(fontSize: 18)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Choose Photo',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Maybe Later Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showShareModal = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF1F3F5),
                                  foregroundColor: const Color(0xFF475569),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Maybe Later',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(ContestItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Tapping photo opens preview)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _previewItem = item;
              });
            },
            child: item.photoAsset.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: item.photoAsset,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF13A27D),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/contest_thumb_2.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    item.photoAsset,
                    fit: BoxFit.cover,
                  ),
          ),

          // Bottom Gradient Banner
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Author Name
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _previewItem = item;
                      });
                    },
                    child: Text(
                      item.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Badges: Votes + Day
                  Row(
                    children: [
                      // Votes Badge
                      Expanded(
                        child: Container(
                          height: 21,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🗳️', style: TextStyle(fontSize: 9.5)),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  'Votes: ${item.votes}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // Day Badge
                      Container(
                        height: 21,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📅', style: TextStyle(fontSize: 9.5)),
                            const SizedBox(width: 3),
                            Text(
                              item.day,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Vote / Voted Button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _handleVote(item),
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: item.isVoted ? const Color(0xFF20B08D) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: item.isVoted
                          ? const Text(
                              'Voted',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('❤️', style: TextStyle(fontSize: 10.5)),
                                SizedBox(width: 4),
                                Text(
                                  'Vote',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
