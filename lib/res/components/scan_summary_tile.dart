import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/risk_badge.dart';
import 'package:retina_scan_app/res/components/scan_image.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Compact one-row summary of a scan: thumbnail, condition and risk.
class ScanSummaryTile extends StatelessWidget {
  const ScanSummaryTile({super.key, required this.result});

  final ScanResultModel result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.all(12.sz),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sz),
            child: SizedBox(
              width: 58.sz,
              height: 58.sz,
              child: ScanImage(path: result.imagePath, iconSize: 26),
            ),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  result.condition,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                6.vSpace,
                Wrap(
                  spacing: 8.sz,
                  runSpacing: 4.sz,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    RiskBadge(risk: result.risk),
                    Text(
                      ScanStrings.confidenceValue(result.confidence),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}