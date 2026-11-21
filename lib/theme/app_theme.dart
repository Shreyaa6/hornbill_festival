import 'package:flutter/material.dart';

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

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      primaryColor: AppColors.primary,
      fontFamily: 'Lato',
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
