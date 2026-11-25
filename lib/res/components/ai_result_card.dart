import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/risk_badge.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Full AI result: condition, risk, confidence, quality warnings,
/// probability of every grade and advice.
class AiResultCard extends StatelessWidget {
  const AiResultCard({super.key, required this.result});

  final ScanResultModel result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color color = result.risk.color(scheme);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 46.sz,
                height: 46.sz,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.sz),
                  color: color.withValues(alpha: 0.14),
                ),
                child: Icon(result.risk.icon, size: 24.sz, color: color),
              ),
              12.hSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ScanStrings.resultTitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    2.vSpace,
                    Text(
                      result.condition,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.vSpace,
          RiskBadge(risk: result.risk),
          16.vSpace,

          // Confidence
          Row(
            children: <Widget>[
              Text(
                ScanStrings.confidenceLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                ScanStrings.confidencePercent(result.confidence),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          6.vSpace,
          _Bar(value: result.confidence, color: color),

          // Quality / confidence warnings
          if (!result.qualityOk || result.lowConfidence) ...<Widget>[
            14.vSpace,
            _Warning(
              title: ApiStrings.qualityWarningTitle,
              lines: <String>[
                ...result.qualityWarnings,
                if (result.lowConfidence) ApiStrings.lowConfidenceWarning,
              ],
            ),
          ],

          // Probabilities
          if (result.probabilities.isNotEmpty) ...<Widget>[
            16.vSpace,
            const Divider(height: 1),
            12.vSpace,
            Text(
              ApiStrings.probabilitiesTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            8.vSpace,
            for (final MapEntry<String, double> e in result.probabilities.entries)
              _ProbabilityRow(
                label: e.key,
                percent: e.value,
                color: ScanResultModel.riskForIndex(
                  ApiStrings.grades.indexOf(e.key),
                ).color(scheme),
                isPredicted: e.key == result.grade,
              ),
          ],
          14.vSpace,

          // Advice
          Container(
            padding: EdgeInsets.all(12.sz),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.sz),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.lightbulb_outline_rounded, size: 20.sz, color: color),
                10.hSpace,
                Expanded(
                  child: Text(
                    result.recommendation,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          10.vSpace,
          Text(
            ScanStrings.disclaimer,
            style: theme.textTheme.labelSmall?.copyWith(
              height: 1.4,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin rounded progress bar.
class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.sz),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6.sz,
        color: color,
        backgroundColor: color.withValues(alpha: 0.15),
      ),
    );
  }
}

/// One grade with its percentage bar.
class _ProbabilityRow extends StatelessWidget {
  const _ProbabilityRow({
    required this.label,
    required this.percent,
    required this.color,
    required this.isPredicted,
  });

  final String label;
  final double percent;
  final Color color;
  final bool isPredicted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sz),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 96.sz,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isPredicted ? FontWeight.w700 : FontWeight.w500,
                color: isPredicted
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: _Bar(value: (percent / 100).clamp(0.0, 1.0), color: color)),
          8.hSpace,
          SizedBox(
            width: 48.sz,
            child: Text(
              '${percent.toStringAsFixed(1)}%',
              textAlign: TextAlign.end,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orange box for image quality problems.
class _Warning extends StatelessWidget {
  const _Warning({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.sz),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.sz),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.warning_amber_rounded, size: 20.sz, color: AppColors.warning),
          10.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
                for (final String line in lines)
                  Padding(
                    padding: EdgeInsets.only(top: 4.sz),
                    child: Text(line, style: theme.textTheme.bodySmall),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}