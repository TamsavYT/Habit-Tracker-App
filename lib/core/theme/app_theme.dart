import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.darkAccent,
        secondary: AppColors.darkAccentSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
      ),
      textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
      ),
      dividerColor: AppColors.darkBorder,
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccentSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
      ),
      textTheme: _textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      dividerColor: AppColors.lightBorder,
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    final base = GoogleFonts.interTextTheme().apply(
      bodyColor: primary,
      displayColor: primary,
    );
    return base.copyWith(
      headlineLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
      headlineMedium: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
      headlineSmall: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600, color: primary),
      titleMedium: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: primary),
      bodySmall: GoogleFonts.inter(fontSize: 12, color: secondary),
    );
  }
}
