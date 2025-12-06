import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00897B); // Teal 600
  static const Color secondary = Color(0xFF26A69A); // Teal 400
  static const Color background = Color(0xFFF5F5F5); // Grey 100
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121); // Grey 900
  static const Color textSecondary = Color(0xFF757575); // Grey 600
  static const Color error = Color(0xFFD32F2F); // Red 700
  static const Color success = Color(0xFF388E3C); // Green 700

  static const Color prayerUpcoming = Color(0xFF00897B);
  static const Color prayerDone = Color(0xFF388E3C);
  static const Color prayerMissed = Color(0xFFD32F2F);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(
    0xFF1C1C1E,
  ); // Slightly lighter black/grey
  static const Color darkSurfaceHighlight = Color(0xFF2C2C2E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkAccent = Color(
    0xFF00897B,
  ); // Keep Teal for brand consistency
}
