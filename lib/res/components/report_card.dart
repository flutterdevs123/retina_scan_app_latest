import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/risk_badge.dart';
import 'package:retina_scan_app/res/components/status_badge.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/date_formatter.dart';

/// Card that summarizes one report in a list.
/// [title] is the other person's name (patient for doctors, doctor for patients).
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.title,
    required this.onTap,
  });

  final ReportModel report;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42.sz,
            height: 42.sz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sz),
              color: scheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.remove_red_eye_rounded,
              size: 22.sz,
              color: scheme.primary,
            ),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    8.hSpace,
                    StatusBadge(status: report.status),
                  ],
                ),
                4.vSpace,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${report.id}  •  ${DateFormatter.relative(report.createdAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    // AI risk helps doctors spot urgent reports quickly.
                    if (report.scan != null) ...<Widget>[
                      6.hSpace,
                      RiskBadge(risk: report.scan!.risk),
                    ],
                  ],
                ),
                8.vSpace,
                Text(
                  report.symptoms,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}