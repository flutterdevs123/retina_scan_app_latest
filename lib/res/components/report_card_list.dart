import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/report_card.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Vertical list of [ReportCard]s, or an empty state when there are none.
class ReportCardList extends StatelessWidget {
  const ReportCardList({
    super.key,
    required this.reports,
    required this.titleOf,
    required this.onTap,
    this.emptyTitle = AppStrings.emptyReportsTitle,
    this.emptyMessage = AppStrings.emptyReportsMsg,
  });

  final List<ReportModel> reports;

  /// Returns the title of each card (usually the other person's name).
  final String Function(ReportModel report) titleOf;

  final ValueChanged<ReportModel> onTap;

  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return EmptyState(title: emptyTitle, message: emptyMessage);
    }

    return Column(
      children: <Widget>[
        for (final ReportModel report in reports)
          Padding(
            padding: EdgeInsets.only(bottom: 12.sz),
            child: ReportCard(
              report: report,
              title: titleOf(report),
              onTap: () => onTap(report),
            ),
          ),
      ],
    );
  }
}