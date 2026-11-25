import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Colored pill showing Draft / Pending / Accepted / Rejected.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ReportStatus status;

  /// Color that represents [status].
  static Color colorOf(ReportStatus status, ColorScheme scheme) {
    switch (status) {
      case ReportStatus.draft:
        return scheme.onSurfaceVariant;
      case ReportStatus.pending:
        return AppColors.warning;
      case ReportStatus.accepted:
        return AppColors.success;
      case ReportStatus.rejected:
        return scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = colorOf(status, theme.colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sz, vertical: 4.sz),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20.sz),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(status.icon, size: 14.sz, color: color),
          5.hSpace,
          Text(
            status.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}