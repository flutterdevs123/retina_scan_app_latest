import 'package:flutter/widgets.dart';
import 'package:retina_scan_app/res/responsive/responsive_utils.dart';

/// Shortcuts to scale any number: `16.sz`, `24.vSpace`, `12.hSpace`.
extension ResponsiveNumExtension on num {
  /// Responsive size (padding, margin, radius, icon size, etc.).
  double get sz => ResponsiveUtils.scaled(toDouble());

  /// Responsive vertical gap.
  SizedBox get vSpace => SizedBox(height: sz);

  /// Responsive horizontal gap.
  SizedBox get hSpace => SizedBox(width: sz);
}

/// Screen information shortcuts.
/// Names are kept different from GetX context extensions to avoid conflicts.
extension ResponsiveContextExtension on BuildContext {
  /// Current screen size.
  Size get deviceSize => MediaQuery.sizeOf(this);

  /// True when the device is in landscape mode.
  bool get isLandscapeMode =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// True when the device is in portrait mode.
  bool get isPortraitMode => !isLandscapeMode;

  /// Current device category.
  DeviceType get deviceCategory => ResponsiveUtils.deviceTypeOf(deviceSize);

  /// True for phones.
  bool get isMobileDevice => deviceCategory == DeviceType.mobile;

  /// True for tablets.
  bool get isTabletDevice => deviceCategory == DeviceType.tablet;
}