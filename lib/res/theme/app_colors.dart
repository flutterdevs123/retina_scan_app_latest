import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
/// Never hard-code a color anywhere else.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF0E7C86);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFF3A6EA5);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF5F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F1B2D);
  static const Color lightTextSecondary = Color(0xFF5B6B7C);
  static const Color lightBorder = Color(0xFFD9E2EA);

  // Light background gradient (top -> bottom).
  static const Color lightGradientStart = Color(0xFFE3F4F6);
  static const Color lightGradientEnd = Color(0xFFF5F8FA);

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF35C9D4);
  static const Color darkOnPrimary = Color(0xFF031A1C);
  static const Color darkSecondary = Color(0xFF7FA8D8);
  static const Color darkOnSecondary = Color(0xFF0A1625);
  static const Color darkBackground = Color(0xFF0B1118);
  static const Color darkSurface = Color(0xFF131C26);
  static const Color darkTextPrimary = Color(0xFFE8EEF4);
  static const Color darkTextSecondary = Color(0xFF9AA9B8);
  static const Color darkBorder = Color(0xFF263444);

  // Dark background gradient (top -> bottom).
  static const Color darkGradientStart = Color(0xFF10252D);
  static const Color darkGradientEnd = Color(0xFF0B1118);

  // ---------------------------------------------------------------------------
  // Status colors (same in both themes)
  // ---------------------------------------------------------------------------
  static const Color error = Color(0xFFD64545);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF2E9E6B);
  static const Color warning = Color(0xFFE0A030);
}