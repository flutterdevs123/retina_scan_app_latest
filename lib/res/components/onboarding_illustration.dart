import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Icon based illustration: soft rings, a gradient core and two floating chips.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.icon,
    required this.accentIcons,
    this.size = 260,
  });

  /// Main icon in the center.
  final IconData icon;

  /// Small floating icons (only the first two are shown).
  final List<IconData> accentIcons;

  /// Design size (scaled automatically per device).
  final double size;

  /// Positions of the floating chips inside the illustration.
  static const List<Alignment> _chipAlignments = <Alignment>[
    Alignment(0.82, -0.62),
    Alignment(-0.85, 0.58),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double box = size.sz;
    final double coreSize = box * 0.42;

    return SizedBox(
      width: box,
      height: box,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _Ring(diameter: box, color: scheme.primary.withValues(alpha: 0.06)),
          _Ring(
            diameter: box * 0.74,
            color: scheme.primary.withValues(alpha: 0.1),
          ),
          // Gradient core with the main icon.
          Container(
            width: coreSize,
            height: coreSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(coreSize * 0.3),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[scheme.primary, scheme.secondary],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.35),
                  blurRadius: coreSize * 0.35,
                  offset: Offset(0, coreSize * 0.12),
                ),
              ],
            ),
            child: Icon(icon, size: coreSize * 0.5, color: scheme.onPrimary),
          ),
          for (int i = 0; i < accentIcons.length && i < _chipAlignments.length; i++)
            Align(
              alignment: _chipAlignments[i],
              child: _AccentChip(icon: accentIcons[i], size: box * 0.18),
            ),
        ],
      ),
    );
  }
}

/// Plain circle used for the soft background rings.
class _Ring extends StatelessWidget {
  const _Ring({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// Small floating circle that holds a decorative icon.
class _AccentChip extends StatelessWidget {
  const _AccentChip({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surface,
        border: Border.all(color: scheme.outline),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.18),
            blurRadius: size * 0.5,
            offset: Offset(0, size * 0.15),
          ),
        ],
      ),
      child: Icon(icon, size: size * 0.5, color: scheme.primary),
    );
  }
}