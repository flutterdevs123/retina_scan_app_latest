import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Reusable app logo: gradient squircle with an icon (eye by default).
///
/// Pass [scanAnimation] (0..1, usually a repeating controller) to show a
/// scanning line moving over the logo. Leave it null for a static logo.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 104,
    this.scanAnimation,
    this.icon = Icons.remove_red_eye_rounded,
  });

  /// Design size of the logo (scaled automatically per device).
  final double size;

  /// Optional animation that drives the scanning line.
  final Animation<double>? scanAnimation;

  /// Icon drawn in the center of the logo.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double logoSize = size.sz;
    final BorderRadius radius = BorderRadius.circular(logoSize * 0.3);

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[scheme.primary, scheme.secondary],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: logoSize * 0.3,
            offset: Offset(0, logoSize * 0.12),
          ),
        ],
      ),
      // Clip so the scan line never leaves the rounded shape.
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(icon, size: logoSize * 0.46, color: scheme.onPrimary),
            if (scanAnimation != null)
              _ScanLine(
                animation: scanAnimation!,
                width: logoSize * 0.7,
                color: scheme.onPrimary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Thin glowing line that moves smoothly from top to bottom and back.
class _ScanLine extends StatelessWidget {
  const _ScanLine({
    required this.animation,
    required this.width,
    required this.color,
  });

  final Animation<double> animation;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // Cosine easing gives a smooth ping-pong between 0 and 1.
        final double t = 0.5 - 0.5 * math.cos(2 * math.pi * animation.value);
        return Align(alignment: Alignment(0, -1 + 2 * t), child: child);
      },
      child: Container(
        width: width,
        height: 2.5.sz,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(2.sz),
          boxShadow: <BoxShadow>[
            BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8.sz),
          ],
        ),
      ),
    );
  }
}