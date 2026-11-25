import 'package:flutter/material.dart';

/// Expanding, fading rings (radar / ripple effect) drawn around the logo.
///
/// [size] is the final outer diameter (already scaled by the caller).
class PulseRings extends StatelessWidget {
  const PulseRings({
    super.key,
    required this.animation,
    required this.color,
    required this.size,
    this.ringCount = 3,
  });

  /// Repeating animation (0..1) that drives the rings.
  final Animation<double> animation;

  /// Ring color.
  final Color color;

  /// Outer diameter of the widget.
  final double size;

  /// How many rings are visible at the same time.
  final int ringCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PulseRingsPainter(
          animation: animation,
          color: color,
          ringCount: ringCount,
        ),
      ),
    );
  }
}

class _PulseRingsPainter extends CustomPainter {
  _PulseRingsPainter({
    required this.animation,
    required this.color,
    required this.ringCount,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final int ringCount;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double minRadius = size.width * 0.24;
    final double maxRadius = size.width * 0.5;

    for (int i = 0; i < ringCount; i++) {
      // Each ring starts at a different point of the cycle.
      final double phase = (animation.value + i / ringCount) % 1.0;
      final double radius = minRadius +
          (maxRadius - minRadius) * Curves.easeOut.transform(phase);

      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = color.withValues(alpha: (1 - phase) * 0.35);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.ringCount != ringCount;
}