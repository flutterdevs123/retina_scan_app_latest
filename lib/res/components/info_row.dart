import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Icon + small label + bold value. Used in profile and detail cards.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 38.sz,
          height: 38.sz,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sz),
            color: scheme.primary.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: 19.sz, color: scheme.primary),
        ),
        12.hSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              2.vSpace,
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}