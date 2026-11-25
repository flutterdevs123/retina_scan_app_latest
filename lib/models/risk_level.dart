import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// How risky the AI thinks a scan (or a single finding) is.
enum RiskLevel {
  low,
  moderate,
  high;

  /// Text shown in badges.
  String get label => switch (this) {
    RiskLevel.low => ScanStrings.riskLow,
    RiskLevel.moderate => ScanStrings.riskModerate,
    RiskLevel.high => ScanStrings.riskHigh,
  };

  /// Icon that represents the risk.
  IconData get icon => switch (this) {
    RiskLevel.low => Icons.verified_rounded,
    RiskLevel.moderate => Icons.warning_amber_rounded,
    RiskLevel.high => Icons.error_rounded,
  };

  /// Color that represents the risk (green, orange, red).
  Color color(ColorScheme scheme) => switch (this) {
    RiskLevel.low => AppColors.success,
    RiskLevel.moderate => AppColors.warning,
    RiskLevel.high => scheme.error,
  };
}