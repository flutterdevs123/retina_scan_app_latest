import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/risk_level.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Colored pill showing Low / Moderate / High Risk.
class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.risk});

  final RiskLevel risk;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = risk.color(theme.colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.sz, vertical: 3.sz),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20.sz),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(risk.icon, size: 13.sz, color: color),
          4.hSpace,
          Text(
            risk.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}