import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Builds the light and dark [ThemeData] of the app.
class AppTheme {
  AppTheme._();

  /// Corner radius shared by inputs and cards.
  static const double _radius = 12.0;

  /// Light theme.
  static ThemeData get light => _build(
    scaffoldColor: AppColors.lightBackground,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
    ),
  );

  /// Dark theme.
  static ThemeData get dark => _build(
    scaffoldColor: AppColors.darkBackground,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
    ),
  );

  /// Shared builder so light and dark themes don't duplicate code (DRY).
  static ThemeData _build({
    required ColorScheme scheme,
    required Color scaffoldColor,
  }) {
    final ThemeData base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
    );

    // Poppins font for all text styles.
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme(base.textTheme)
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    final bool isLight = scheme.brightness == Brightness.light;

    return base.copyWith(
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        // Keeps status bar icons readable in both themes.
        systemOverlayStyle:
        isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: scheme.onSurfaceVariant),
        border: _inputBorder(scheme.outline),
        enabledBorder: _inputBorder(scheme.outline),
        focusedBorder: _inputBorder(scheme.primary, width: 1.5),
        errorBorder: _inputBorder(scheme.error),
        focusedErrorBorder: _inputBorder(scheme.error, width: 1.5),
      ),
    );
  }

  /// Reusable outline border for text fields.
  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}