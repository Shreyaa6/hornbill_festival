import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xFF20B08D);
  static const Color primaryDark = Color(0xFF1DCC98);
  static const Color primaryLight = Color(0xFFD3FFF4);
  static const Color navy = Color(0xFF03314B);
  static const Color darkNavy = Color(0xFF000E15);
  static const Color scaffoldBg = Color(0xFFF6F6F6);
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFECECEC);
  static const Color borderLight = Color(0xFFEBEBEB);
  static const Color divider = Color(0xFFD7D7D7);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF888484);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color warningGold = Color(0xFFEBB511);
  static const Color warningBg = Color(0xFFFFF5D5);
  static const Color errorRed = Color(0xFFCA234F);
  static const Color redAccent = Color(0xFFE63946);
}

class AppTextStyles {
  // --- Curved Deep Teal Screen Headers ---
  static const TextStyle headerTitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w900,
    fontSize: 28,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.15,
  );

  static const TextStyle headerSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.white70,
    letterSpacing: 0.1,
    height: 1.2,
  );

  // --- Home / Section Greeting Headers (White/Grey BG) ---
  static const TextStyle greetingHey = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 20,
    color: Color(0xFF1E293B),
  );

  static const TextStyle greetingTitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w900,
    fontSize: 24,
    color: Color(0xFF0F172A),
    letterSpacing: -0.3,
  );

  // --- Sheet & Section Titles ---
  static const TextStyle sheetTitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 18,
    color: Color(0xFF1E293B),
    letterSpacing: -0.2,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w900,
    fontSize: 18,
    color: Color(0xFF0F172A),
    letterSpacing: -0.2,
  );

  static const TextStyle sectionSubheading = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Color(0xFF64748B),
  );

  // --- Card Typography ---
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 16,
    color: Color(0xFF0F172A),
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Color(0xFF64748B),
  );

  static const TextStyle cardTitleSmall = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 13.5,
    color: Color(0xFF1E293B),
  );

  static const TextStyle cardSubtitleSmall = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 11.5,
    color: Color(0xFF64748B),
  );

  // --- Filter Pills & Dropdowns ---
  static const TextStyle filterPillActive = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle filterPillInactive = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Color(0xFF1E293B),
  );

  static const TextStyle dropdownPillText = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 14.5,
    color: Color(0xFF1E293B),
  );

  // --- Body Typography ---
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.45,
    color: Color(0xFF334155),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w500,
    fontSize: 13.5,
    height: 1.45,
    color: Color(0xFF334155),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: Color(0xFF64748B),
  );

  // --- Buttons & Actions ---
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 14.5,
    color: Colors.white,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: Color(0xFF20B08D),
  );

  // --- Badges & Microcopy ---
  static const TextStyle badge = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w800,
    fontSize: 11,
    color: Colors.white,
  );

  static const TextStyle emptyStateTitle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: Color(0xFF64748B),
  );
}

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      primaryColor: AppColors.primary,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        },
      ),
      fontFamily: 'Lato',
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headerTitle,
        headlineMedium: AppTextStyles.greetingTitle,
        headlineSmall: AppTextStyles.greetingHey,
        titleLarge: AppTextStyles.sectionHeading,
        titleMedium: AppTextStyles.cardTitle,
        titleSmall: AppTextStyles.cardTitleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonPrimary,
        labelMedium: AppTextStyles.filterPillActive,
        labelSmall: AppTextStyles.badge,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.navy,
        surface: AppColors.cardBg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
