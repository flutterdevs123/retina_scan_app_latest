import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Accent color of a stat card.
enum StatTone {
  primary,
  success,
  warning,
  danger;

  Color color(ColorScheme scheme) => switch (this) {
    StatTone.primary => scheme.primary,
    StatTone.success => AppColors.success,
    StatTone.warning => AppColors.warning,
    StatTone.danger => scheme.error,
  };
}

/// Compact stat tile: small icon on the left, value and label on the right.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.tone = StatTone.primary,
  });

  final IconData icon;
  final String value;
  final String label;
  final StatTone tone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color color = tone.color(scheme);

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 12.sz, vertical: 10.sz),
      child: Row(
        children: <Widget>[
          Container(
            width: 36.sz,
            height: 36.sz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sz),
              color: color.withValues(alpha: 0.14),
            ),
            child: Icon(icon, size: 19.sz, color: color),
          ),
          10.hSpace,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}