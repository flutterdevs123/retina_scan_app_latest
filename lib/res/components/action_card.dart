import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Tappable card row: icon, title, subtitle and an arrow.
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  /// Icon shown in the tinted box.
  final IconData icon;

  /// Card heading.
  final String title;

  /// Short description under the heading.
  final String subtitle;

  /// Tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 48.sz,
            height: 48.sz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.sz),
              color: scheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(icon, size: 24.sz, color: scheme.primary),
          ),
          14.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                2.vSpace,
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 24.sz,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}