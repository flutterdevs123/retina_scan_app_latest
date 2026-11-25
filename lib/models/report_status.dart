import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';

/// Review state of a retina report.
enum ReportStatus {
  draft,
  pending,
  accepted,
  rejected;

  /// Converts the server status text (draft, submitted, approved, rejected...).
  static ReportStatus fromApi(String? value) {
    final String s = (value ?? '').toLowerCase();
    if (s.contains('draft')) return ReportStatus.draft;
    if (s.contains('approv') || s.contains('accept')) return ReportStatus.accepted;
    if (s.contains('reject')) return ReportStatus.rejected;
    return ReportStatus.pending;
  }

  String get label => switch (this) {
    ReportStatus.draft => ApiStrings.statusDraft,
    ReportStatus.pending => AppStrings.statusPending,
    ReportStatus.accepted => AppStrings.statusAccepted,
    ReportStatus.rejected => AppStrings.statusRejected,
  };

  IconData get icon => switch (this) {
    ReportStatus.draft => Icons.edit_note_rounded,
    ReportStatus.pending => Icons.hourglass_top_rounded,
    ReportStatus.accepted => Icons.check_circle_rounded,
    ReportStatus.rejected => Icons.cancel_rounded,
  };
}

/// Options of the filter chips above report lists.
enum ReportFilter {
  all,
  draft,
  pending,
  accepted,
  rejected;

  String get label => switch (this) {
    ReportFilter.all => AppStrings.filterAll,
    ReportFilter.draft => ApiStrings.statusDraft,
    ReportFilter.pending => AppStrings.statusPending,
    ReportFilter.accepted => AppStrings.statusAccepted,
    ReportFilter.rejected => AppStrings.statusRejected,
  };

  bool matches(ReportStatus status) => switch (this) {
    ReportFilter.all => true,
    ReportFilter.draft => status == ReportStatus.draft,
    ReportFilter.pending => status == ReportStatus.pending,
    ReportFilter.accepted => status == ReportStatus.accepted,
    ReportFilter.rejected => status == ReportStatus.rejected,
  };
}