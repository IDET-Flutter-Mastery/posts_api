import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A single source of truth for color — everything in the app should
/// reach for one of these instead of a bare `Color(0xFF...)`, so a
/// palette-wide tweak stays a one-file change.
///
/// Updated to a cozy pastel brown and green palette.
class AppColors {
  AppColors._();

  static const Color sage = Color(0xFF8DA399);
  static const Color sageDeep = Color(0xFF5A7065);
  static const Color surface = Color(0xFFF7F5F0);
  static const Color ink = Color(0xFF3B332E);
  static const Color inkMuted = Color(0xFF7C726C);
}

/// The app's single [ThemeData]. Built around Google Fonts'
/// **Josefin Sans** and styled with a warm pastel brown and green palette.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sage,
      brightness: Brightness.light,
    );

    final textTheme = GoogleFonts.josefinSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.josefinSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleLarge: GoogleFonts.josefinSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleMedium: GoogleFonts.josefinSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.josefinSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.inkMuted,
      ),
      labelLarge: GoogleFonts.josefinSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.josefinSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.sageDeep.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.sage.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.sage.withValues(alpha: 0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.josefinSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.josefinSans(fontWeight: FontWeight.w600),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.sageDeep,
        titleTextStyle: GoogleFonts.josefinSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        subtitleTextStyle: GoogleFonts.josefinSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.inkMuted,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE3DFD5),
        space: 1,
      ),
    );
  }
}
