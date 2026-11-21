import 'package:flutter/material.dart';

class HornbillIntroScreen extends StatelessWidget {
  final VoidCallback? onEnter;

  const HornbillIntroScreen({super.key, this.onEnter});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Hero Photo
          Image.asset(
            'assets/images/bg_2.jpg',
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.25),
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(24, topInset + 40, 24, 120 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Text
                const Text(
                  'Hornbill',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  'Festival',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  'Nagaland.',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Music · Cultural · Heritage',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),

                const Spacer(),

                // White Rounded Pill Button: "Hornbill Festival 2025"
                GestureDetector(
                  onTap: onEnter,
                  child: Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Hornbill Festival 2025',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF20B08D),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
