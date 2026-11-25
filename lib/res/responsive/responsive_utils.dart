import 'package:flutter/widgets.dart';

/// Device categories based on the shortest side of the screen.
enum DeviceType { mobile, tablet, desktop }

/// Holds the global responsive configuration of the app.
///
/// All sizes are scaled using the SHORTEST side of the screen, so the UI
/// looks the same in portrait and landscape instead of becoming huge.
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Width of the device the UI was originally designed on.
  static const double designWidth = 375.0;

  /// Shortest-side breakpoints used to detect the device type.
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  /// Maximum width the app content can take on wide screens.
  static const double maxContentWidth = 600.0;

  /// Limits so tiny phones don't shrink too much and tablets don't grow too much.
  static const double _minScale = 0.8;
  static const double _maxScale = 1.4;

  static Size _screenSize = const Size(designWidth, 812);
  static double _scale = 1.0;

  /// Recalculates the scale factor. Called by [ResponsiveWrapper] whenever
  /// the screen size or orientation changes.
  static void update(MediaQueryData data) {
    _screenSize = data.size;
    _scale = (data.size.shortestSide / designWidth)
        .clamp(_minScale, _maxScale)
        .toDouble();
  }

  /// Current scale factor.
  static double get scale => _scale;

  /// Scales a design value (padding, icon size, radius, etc.).
  static double scaled(double value) => value * _scale;

  /// Whether the screen is currently in landscape mode.
  static bool get isLandscape => _screenSize.width > _screenSize.height;

  /// Detects the device type from a given screen size.
  static DeviceType deviceTypeOf(Size size) {
    final double shortest = size.shortestSide;
    if (shortest < mobileBreakpoint) return DeviceType.mobile;
    if (shortest < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}