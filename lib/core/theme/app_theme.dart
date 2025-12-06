import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sallay/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkAccent,
        brightness: Brightness.dark,
        primary: AppColors.darkAccent,
        surface: AppColors.darkBackground,
        onSurface: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
          bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Pill shape
            side: const BorderSide(color: AppColors.darkSurfaceHighlight),
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: AppColors.darkSurfaceHighlight,
            width: 1,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    );
  }
}
