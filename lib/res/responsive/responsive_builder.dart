import 'package:flutter/widgets.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/responsive/responsive_utils.dart';

/// Lets a screen provide a different layout for landscape / tablet.
/// Only [mobile] is required; it is used as the fallback for everything else.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.landscape,
  });

  /// Default layout (portrait phone).
  final Widget mobile;

  /// Optional layout for tablets.
  final Widget? tablet;

  /// Optional layout for landscape orientation.
  final Widget? landscape;

  @override
  Widget build(BuildContext context) {
    if (context.isLandscapeMode && landscape != null) return landscape!;
    if (context.deviceCategory != DeviceType.mobile && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}