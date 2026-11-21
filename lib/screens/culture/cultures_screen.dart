import 'package:flutter/material.dart';
import '../../data/mock_user.dart';
import '../../widgets/app_header_bar.dart';
import 'festivals_screen.dart';
import 'tribes_screen.dart';

enum CultureSubPage {
  main,
  festivals,
  tribes,
}

class CulturesFlowScreen extends StatefulWidget {
  final ValueChanged<bool>? onHeaderVisibilityChanged;

  const CulturesFlowScreen({super.key, this.onHeaderVisibilityChanged});

  @override
  State<CulturesFlowScreen> createState() => CulturesFlowScreenState();
}

class CulturesFlowScreenState extends State<CulturesFlowScreen> {
  CultureSubPage _currentPage = CultureSubPage.main;

  void openFestivals() {
    setState(() {
      _currentPage = CultureSubPage.festivals;
    });
    widget.onHeaderVisibilityChanged?.call(false);
  }

  void openTribes() {
    setState(() {
      _currentPage = CultureSubPage.tribes;
    });
    widget.onHeaderVisibilityChanged?.call(false);
  }

  void goBackToMain() {
    setState(() {
      _currentPage = CultureSubPage.main;
    });
    widget.onHeaderVisibilityChanged?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == CultureSubPage.main,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentPage != CultureSubPage.main) {
          goBackToMain();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switch (_currentPage) {
          CultureSubPage.main => CulturesScreen(
              key: const ValueKey('cultures_main_view'),
              onOpenFestivals: openFestivals,
              onOpenTribes: openTribes,
            ),
          CultureSubPage.festivals => FestivalsScreen(
              key: const ValueKey('festivals_screen_view'),
              onBack: goBackToMain,
            ),
          CultureSubPage.tribes => TribesScreen(
              key: const ValueKey('tribes_screen_view'),
              onBack: goBackToMain,
            ),
        },
      ),
    );
  }
}

class CulturesScreen extends StatefulWidget {
  final VoidCallback? onOpenFestivals;
  final VoidCallback? onOpenTribes;

  const CulturesScreen({
    super.key,
    this.onOpenFestivals,
    this.onOpenTribes,
  });

  @override
  State<CulturesScreen> createState() => _CulturesScreenState();
}

class _CulturesScreenState extends State<CulturesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return;
    if (q.contains('tribe') ||
        q.contains('angami') ||
        q.contains('ao') ||
        q.contains('konyak') ||
        q.contains('sumi') ||
        q.contains('lotha')) {
      if (widget.onOpenTribes != null) {
        widget.onOpenTribes!();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TribesScreen()));
      }
    } else {
      if (widget.onOpenFestivals != null) {
        widget.onOpenFestivals!();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FestivalsScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mockUser = MockUser();
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            const AppHeaderBar(showBackButton: false),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 100 + bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Greeting Header
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
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: Color(0xFF1E293B),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Explore Cultures',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
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
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _handleSearch,
                        textInputAction: TextInputAction.search,
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
                    const SizedBox(height: 20),

                    // Two Large Side-by-Side Cards (Festivals & Tribes)
                    Row(
                      children: [
                        // Festivals Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onOpenFestivals != null) {
                                widget.onOpenFestivals!();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FestivalsScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/festivals_card.png',
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 0,
                                      right: 0,
                                      child: const Text(
                                        'Festivals',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Tribes Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onOpenTribes != null) {
                                widget.onOpenTribes!();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TribesScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/tribes_card.png',
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 0,
                                      right: 0,
                                      child: const Text(
                                        'Tribes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4,
                                            ),
                                          ],
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
                    const SizedBox(height: 20),

                    // Nagaland Heritage: View Cultural Calendar Banner Card
                    GestureDetector(
                      onTap: () {
                        if (widget.onOpenFestivals != null) {
                          widget.onOpenFestivals!();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FestivalsScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDF8),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF3E8D0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 3D Calendar Icon
                            Image.asset(
                              'assets/images/calendar_3d_icon.png',
                              height: 52,
                              width: 52,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFFD97706),
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'NAGALAND HERITAGE',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: Color(0xFF1E293B),
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'VIEW CULTURAL CALENDER',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Round Teal Button
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF20B08D),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.keyboard_double_arrow_right_rounded,
                                color: Colors.white,
                                size: 22,
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
      ),
    );
  }
}
