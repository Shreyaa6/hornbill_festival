import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/cafe_image.dart';
import '../../services/firebase_service.dart';
import '../../data/mock_user.dart';
import '../../theme/app_theme.dart';

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
  bool _lastVotedStatus = true;
  Timer? _toastTimer;
  ContestItem? _previewItem;
  late Stream<List<Map<String, dynamic>>> _submissionsStream;
  late Stream<Set<String>> _userVotesStream;

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    _submissionsStream = FirebaseService().getSubmissions(dayFilter: _selectedDay);
    try {
      final user = MockUser();
      final userId = user.userId.isNotEmpty
          ? user.userId
          : (user.email.isNotEmpty ? user.email : 'guest_user');
      _userVotesStream = FirebaseService().getUserVotes(userId);
    } catch (_) {
      _userVotesStream = Stream.value(<String>{});
    }
  }

  bool handleBack() {
    if (_previewItem != null) {
      setState(() => _previewItem = null);
      return true;
    }
    return false;
  }

  late final List<ContestItem> _fallbackItems = [
    ContestItem(
      id: '1',
      authorName: 'Tepuduho Benjamin',
      photoAsset: 'assets/images/contest_thumb_1.png',
      votes: 141,
      day: '08',
      isVoted: false,
    ),
    ContestItem(
      id: '2',
      authorName: 'Tepuduho Benjamin',
      photoAsset: 'assets/images/contest_thumb_2.png',
      fullPhotoAsset: 'assets/images/contest_photo_warrior_full.webp',
      votes: 123,
      day: '08',
      isVoted: false,
    ),
  ];

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _handleVote(ContestItem item) {
    final bool willVote = !item.isVoted;
    setState(() {
      item.isVoted = willVote;
      item.votes = willVote ? (item.votes + 1) : ((item.votes > 0) ? item.votes - 1 : 0);
      _lastVotedStatus = willVote;
      _showToast = true;
    });

    final user = MockUser();
    final userId = user.userId.isNotEmpty
        ? user.userId
        : (user.email.isNotEmpty ? user.email : 'guest_user');
    try {
      FirebaseService().castVote(
        userId: userId,
        submissionDocId: item.id,
        isVoting: willVote,
      );
    } catch (_) {}

    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  Future<void> _onAddPhotoPressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
    );

    if (picked == null || !mounted) return;

    // Directly open photo confirmation modal (no crop screen, no manual name/date entry)
    _showConfirmPhotoModal(File(picked.path));
  }

  @visibleForTesting
  void showConfirmPhotoModalForTesting(File photoFile) => _showConfirmPhotoModal(photoFile);

  void _showConfirmPhotoModal(File photoFile) {
    final mockUser = MockUser();
    final userName = (mockUser.name.isNotEmpty && mockUser.name != 'Guest User')
        ? mockUser.name
        : 'Hornbill Visitor';

    final now = DateTime.now();
    final selectedDateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    bool isUploading = false;
    bool isSubmitted = false;
    String? errorMessage;
    File currentFile = photoFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: !isUploading,
      enableDrag: !isUploading,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return PopScope(
              canPop: !isUploading,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset + 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Drag Handle
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

                        // Title Bar
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4FAF1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Color(0xFF20B08D),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirm Photo Entry',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    'Hornbill Festival Photo Contest',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isUploading && !isSubmitted)
                              IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    color: Color(0xFF64748B)),
                                onPressed: () =>
                                    Navigator.of(bottomSheetContext).pop(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Image Preview with Upload / Submitted Overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 230,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.file(
                                  currentFile,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // If Uploading
                              if (isUploading)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.65),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF20B08D)),
                                            strokeWidth: 3.5,
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                        Text(
                                          'Uploading photo to contest...',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Please wait a moment',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // If Submitted
                              if (isSubmitted)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F5E4E)
                                          .withOpacity(0.90),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 56,
                                          color: Color(0xFF20B08D),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Submitted!',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Your photo is now live in the contest',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 13,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Submission Info Details (Auto-filled from user data, read-only)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline_rounded,
                                      size: 18, color: Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Photographer',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                  height: 16,
                                  thickness: 1,
                                  color: Color(0xFFF1F5F9)),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 17, color: Color(0xFF64748B)),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    selectedDateStr,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                  height: 16,
                                  thickness: 1,
                                  color: Color(0xFFF1F5F9)),
                              const Row(
                                children: [
                                  Icon(Icons.favorite_border_rounded,
                                      size: 18, color: Color(0xFF64748B)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Starting Votes',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '0 votes',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF20B08D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (errorMessage != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Action Buttons
                        if (!isSubmitted) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF20B08D),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isUploading
                                  ? null
                                  : () async {
                                      setModalState(() {
                                        isUploading = true;
                                        errorMessage = null;
                                      });

                                      try {
                                        final user = MockUser();
                                        final userId = user.userId.isNotEmpty
                                            ? user.userId
                                            : (user.email.isNotEmpty
                                                ? user.email
                                                : 'user_${DateTime.now().millisecondsSinceEpoch}');

                                        // Upload image to Firebase Storage under submissions/
                                        final timestamp = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        final storageFileName =
                                            '${userId}_$timestamp.jpg';
                                        String photoUrl = '';
                                        try {
                                          final ref = FirebaseStorage.instance
                                              .ref()
                                              .child('submissions')
                                              .child(storageFileName);
                                          final task = await ref.putFile(
                                            currentFile,
                                            SettableMetadata(
                                                contentType: 'image/jpeg'),
                                          );
                                          photoUrl =
                                              await task.ref.getDownloadURL();
                                        } catch (e) {
                                          debugPrint("Storage upload error: $e");
                                          photoUrl =
                                              'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/submissions%2F$storageFileName?alt=media';
                                        }

                                        // Add to Firestore collection 'submissions' with votes: 0
                                        final docData = {
                                          'createdAt':
                                              FieldValue.serverTimestamp(),
                                          'fullName': userName,
                                          'localDateString': selectedDateStr,
                                          'photoUrl': photoUrl,
                                          'userID': userId,
                                          'votes': 0, // Explicitly start with 0
                                        };

                                        await FirebaseFirestore.instance
                                            .collection('submissions')
                                            .add(docData);

                                        // Note: DO NOT cast self-vote! Votes remain 0.

                                        // Show Submitted state
                                        setModalState(() {
                                          isUploading = false;
                                          isSubmitted = true;
                                        });

                                        // Auto-close modal after 1.3s
                                        await Future.delayed(
                                            const Duration(milliseconds: 1300));

                                        if (bottomSheetContext.mounted) {
                                          Navigator.of(bottomSheetContext).pop();
                                        }

                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  '🎉 Photo submitted to Contest!'),
                                              backgroundColor:
                                                  Color(0xFF20B08D),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint("Submission error: $e");
                                        setModalState(() {
                                          isUploading = false;
                                          errorMessage =
                                              'Error submitting photo: $e';
                                        });
                                      }
                                    },
                              child: isUploading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Uploading...',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Submit Photo',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          if (!isUploading) ...[
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton.icon(
                                icon: const Icon(
                                    Icons.photo_library_outlined,
                                    size: 18,
                                    color: Color(0xFF64748B)),
                                label: const Text(
                                  'Choose another photo',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? newPicked =
                                      await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 92,
                                  );
                                  if (newPicked != null) {
                                    setModalState(() {
                                      currentFile = File(newPicked.path);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ] else ...[
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4FAF1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF20B08D), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Submitted Successfully!',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F5E4E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDayFilterSheet() async {
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

    final selected = await showAppFilterBottomSheet(
      context: context,
      title: 'Filter by Day',
      items: days,
      selectedItem: _selectedDay,
      sortAlphabetically: false,
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedDay = selected;
        _submissionsStream = FirebaseService().getSubmissions(dayFilter: selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final double bottomMargin = bottomInset > 0 ? bottomInset + 10 : 16;
    const headerColor = Color(0xFF003848);

    return PopScope(
      canPop: _previewItem == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _previewItem != null) {
          setState(() => _previewItem = null);
        }
      },
      child: Scaffold(
        backgroundColor: headerColor,
        body: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Deep Teal Top Header (same style as Tour Guides / Taxis, no photo, no back button)
                  Container(
                    width: double.infinity,
                    color: headerColor,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Photo Contest',
                          style: AppTextStyles.headerTitle,
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Hornbill Festival 2026 • 219 Photos',
                          style: AppTextStyles.headerSubtitle,
                        ),
                        const SizedBox(height: 16),

                        // All Days Filter Pill Tap Region
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _showDayFilterSheet,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDay,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
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

                  // White Rounded Body Sheet (Curved like other screens!)
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
                          stream: _submissionsStream,
                          builder: (context, subSnapshot) {
                            return StreamBuilder<Set<String>>(
                              stream: _userVotesStream,
                              initialData: const <String>{},
                              builder: (context, voteSnapshot) {
                                final userVotedSet = voteSnapshot.data ?? {};

                                List<ContestItem> displayItems;
                                final bool isLoading = subSnapshot.connectionState == ConnectionState.waiting && !subSnapshot.hasData;
                                if (subSnapshot.hasData && subSnapshot.data!.isNotEmpty) {
                                  displayItems = subSnapshot.data!.map((doc) {
                                    final docId = doc['docId']?.toString() ?? doc['id']?.toString() ?? '';
                                    final author = (doc['fullName'] ?? doc['authorName'] ?? 'Photographer').toString().trim();
                                    final photo = (doc['photoUrl'] ?? doc['photo'] ?? '').toString().trim();
                                    final votes = (doc['votes'] as num?)?.toInt() ?? 0;
                                    final localDate = (doc['localDateString'] ?? doc['day'] ?? '').toString();
                                    final isVoted = userVotedSet.contains(docId);

                                    return ContestItem(
                                      id: docId,
                                      authorName: author.isNotEmpty ? author : 'Photographer',
                                      photoAsset: photo,
                                      votes: votes,
                                      day: localDate,
                                      isVoted: isVoted,
                                    );
                                  }).toList();
                                } else {
                                  displayItems = _fallbackItems;
                                  for (final item in displayItems) {
                                    if (userVotedSet.contains(item.id)) {
                                      item.isVoted = true;
                                    }
                                  }
                                }

                                final bool isEmpty = displayItems.isEmpty;

                                return RepaintBoundary(
                                  child: CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  slivers: [
                                    // Authenticity rule banner sliver (Single Line)
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                        child: Container(
                                          height: 38,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFFBEB),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: const Color(0xFFFDE68A),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.shield_outlined,
                                                color: Color(0xFFD97706),
                                                size: 15,
                                              ),
                                              SizedBox(width: 7),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'AI Generated Photos & spam are disqualified',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: -0.1,
                                                      color: Color(0xFF92400E),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    if (isLoading)
                                      const SliverToBoxAdapter(
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 40),
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF20B08D),
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (isEmpty)
                                      SliverToBoxAdapter(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 48),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey[400]),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'No photos found for $_selectedDay',
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      // True Lazy Grid of Cards (Viewport virtualization)
                                      SliverPadding(
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin + 85),
                                        sliver: SliverGrid(
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 14,
                                            childAspectRatio: 0.69,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              final item = displayItems[index];
                                              return ContestCard(
                                                item: item,
                                                onVote: () => _handleVote(item),
                                                onPreview: () => setState(() => _previewItem = item),
                                              );
                                            },
                                            childCount: displayItems.length,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Floating Toast: "🎉 Vote Counted" or "Vote Removed" with pop animation
            if (_showToast)
              Positioned(
                left: 16,
                right: 16,
                bottom: bottomMargin + 67 + 14,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('toast_anim_$_lastVotedStatus'),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  builder: (context, val, child) {
                    return Opacity(
                      opacity: val.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.92 + (0.08 * val),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _lastVotedStatus
                          ? const Color(0xFFE0FAF3)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _lastVotedStatus
                            ? const Color(0xFF67DFBE)
                            : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _lastVotedStatus ? '🎉' : 'ℹ️',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _lastVotedStatus ? 'Vote Counted' : 'Vote Removed',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: _lastVotedStatus
                                ? const Color(0xFF13A27D)
                                : const Color(0xFF475569),
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
                  onTap: _onAddPhotoPressed,
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

            // Screen 2: Photo Detail & Zoom Modal (Menu-modal UX with light blur, controlled size, circular cross, author details & vote)
            if (_previewItem != null)
              Positioned.fill(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('preview_anim_${_previewItem!.id}'),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  builder: (context, val, child) {
                    return Opacity(
                      opacity: val.clamp(0.0, 1.0),
                      child: child,
                    );
                  },
                  child: Stack(
                    children: [
                      // Backdrop with light blur (like menu modal)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _previewItem = null),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.40),
                          ),
                        ),
                      ),

                      // Centered Dialog (controlled size, not huge!)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.85, end: 1.0),
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxWidth: 420,
                                maxHeight: MediaQuery.of(context).size.height * 0.74,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 18,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Photo with Pinch-to-Zoom & Professional Full Resolution Transition
                                      Flexible(
                                        child: Container(
                                          color: const Color(0xFF0F172A),
                                          width: double.infinity,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              InteractiveViewer(
                                                panEnabled: true,
                                                minScale: 0.9,
                                                maxScale: 4.0,
                                                child: (_previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset).startsWith('http')
                                                    ? CachedNetworkImage(
                                                        imageUrl: kIsWeb
                                                            ? (CafeImage.getWebSafeUrl(_previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset) ??
                                                                (_previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset))
                                                            : (_previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset),
                                                        fit: BoxFit.contain,
                                                        memCacheWidth: 1200,
                                                        fadeInDuration: const Duration(milliseconds: 150),
                                                        placeholder: (context, url) => (_previewItem!.photoAsset.isNotEmpty &&
                                                                _previewItem!.photoAsset != (_previewItem!.fullPhotoAsset ?? ''))
                                                            ? CachedNetworkImage(
                                                                imageUrl: kIsWeb
                                                                    ? (CafeImage.getWebSafeUrl(_previewItem!.photoAsset) ?? _previewItem!.photoAsset)
                                                                    : _previewItem!.photoAsset,
                                                                fit: BoxFit.contain,
                                                                memCacheWidth: 500,
                                                              )
                                                            : Container(
                                                                color: const Color(0xFF1E293B),
                                                              ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/images/contest_photo_warrior_full.webp',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        _previewItem!.fullPhotoAsset ?? _previewItem!.photoAsset,
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),

                                              // Sleek floating HD badge on top-left
                                              Positioned(
                                                top: 12,
                                                left: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.55),
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: const Color(0xFF20B08D).withValues(alpha: 0.8),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.hd_outlined, color: Color(0xFF20B08D), size: 15),
                                                      SizedBox(width: 4.5),
                                                      Text(
                                                        'Full Resolution',
                                                        style: TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
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

                                      // Bottom Info Bar: Name, Votes, Date, Vote Button
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _previewItem!.authorName,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 16.5,
                                                      color: Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${_previewItem!.votes} votes',
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w800,
                                                          color: Color(0xFF20B08D),
                                                        ),
                                                      ),
                                                      const Text(
                                                        ' • ',
                                                        style: TextStyle(
                                                          color: Color(0xFF94A3B8),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        _previewItem!.day.startsWith('Day')
                                                            ? _previewItem!.day
                                                            : 'Day ${_previewItem!.day}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 12.5,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xFF64748B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            // Interactive Animated Vote Button
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                _handleVote(_previewItem!);
                                                setState(() {});
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 240),
                                                curve: Curves.easeOutCubic,
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
                                                decoration: BoxDecoration(
                                                  color: _previewItem!.isVoted
                                                      ? const Color(0xFF20B08D)
                                                      : const Color(0xFFFFF1F2),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: _previewItem!.isVoted
                                                        ? const Color(0xFF20B08D)
                                                        : const Color(0xFFFECDD3),
                                                    width: 1,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: _previewItem!.isVoted
                                                          ? const Color(0xFF20B08D).withValues(alpha: 0.3)
                                                          : Colors.black.withValues(alpha: 0.04),
                                                      blurRadius: 6,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      _previewItem!.isVoted
                                                          ? Icons.favorite_rounded
                                                          : Icons.favorite_border_rounded,
                                                      size: 14,
                                                      color: _previewItem!.isVoted
                                                          ? Colors.white
                                                          : const Color(0xFFE11D48),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      _previewItem!.isVoted ? 'Voted' : 'Vote',
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w800,
                                                        color: _previewItem!.isVoted
                                                            ? Colors.white
                                                            : const Color(0xFFE11D48),
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

                                  // Floating Close Button with White Circular Background (Exact match with menu modal)
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => setState(() => _previewItem = null),
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.25),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Color(0xFF1E293B),
                                          size: 20,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContestCard extends StatefulWidget {
  final ContestItem item;
  final VoidCallback onVote;
  final VoidCallback onPreview;

  const ContestCard({
    super.key,
    required this.item,
    required this.onVote,
    required this.onPreview,
  });

  @override
  State<ContestCard> createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Photo (Tapping opens preview with pop transition)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPreview,
            child: item.photoAsset.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: kIsWeb
                        ? (CafeImage.getWebSafeUrl(item.photoAsset) ?? item.photoAsset)
                        : item.photoAsset,
                    fit: BoxFit.cover,
                    memCacheWidth: 500,
                    fadeInDuration: const Duration(milliseconds: 120),
                    placeholder: (context, url) => Container(
                      color: const Color(0xFFE2E8F0),
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

          // Floating Day Badge on Top Left
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.52),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 9,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3.5),
                  Text(
                    item.day.startsWith('Day') ? item.day : 'Day ${item.day}',
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
          ),

          // Floating Votes Badge on Top Right
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 3),
              decoration: BoxDecoration(
                color: item.isVoted
                    ? const Color(0xFF20B08D)
                    : Colors.black.withValues(alpha: 0.52),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: item.isVoted
                      ? const Color(0xFF20B08D)
                      : Colors.white.withValues(alpha: 0.22),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.isVoted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 9.5,
                    color: item.isVoted ? Colors.white : const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(width: 3.5),
                  Text(
                    '${item.votes}',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Dark Gradient & Details
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
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.3, 0.65, 1.0],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Author Name with Photographer Icon
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onPreview,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Interactive Vote Button (Smooth color transition, fixed size - no weird scaling)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onVote,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      height: 32,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: item.isVoted
                            ? const Color(0xFF20B08D)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: item.isVoted
                                ? const Color(0xFF20B08D).withValues(alpha: 0.35)
                                : Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: item.isVoted
                              ? const Row(
                                  key: ValueKey('voted_btn'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Voted',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                )
                              : const Row(
                                  key: ValueKey('vote_btn'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      size: 13,
                                      color: Color(0xFFE11D48),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Vote',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFE11D48),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
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
