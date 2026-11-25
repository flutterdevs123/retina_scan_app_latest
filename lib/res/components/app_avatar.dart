import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Round gradient avatar that shows the initials of a person.
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.initials, this.size = 48});

  /// One or two letters shown in the center.
  final String initials;

  /// Design diameter (scaled automatically per device).
  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      width: size.sz,
      height: size.sz,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[scheme.primary, scheme.secondary],
        ),
      ),
      child: Text(
        initials,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}