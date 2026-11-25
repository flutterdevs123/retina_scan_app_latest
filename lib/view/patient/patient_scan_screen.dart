import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retina_scan_app/models/risk_level.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/res/components/ai_result_card.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/scan_image_viewer.dart';
import 'package:retina_scan_app/res/components/scan_preview_card.dart';
import 'package:retina_scan_app/res/components/tab_header.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/patient/patient_scan_controller.dart';

/// Patient Scan tab: pick image -> instant AI analysis -> result -> send.
class PatientScanScreen extends GetView<PatientScanController> {
  const PatientScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        const TabHeader(
          title: ScanStrings.scanTitle,
          subtitle: ScanStrings.scanSubtitle,
        ),
        20.vSpace,
        Obx(() {
          switch (controller.stage.value) {
            case ScanStage.idle:
              return _IdleView(controller: controller);
            case ScanStage.analyzing:
              return _AnalyzingView(controller: controller);
            case ScanStage.result:
              return _ResultView(controller: controller);
          }
        }),
      ],
    );
  }
}

/// Step 1: choose camera or gallery.
class _IdleView extends StatelessWidget {
  const _IdleView({required this.controller});

  final PatientScanController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Obx(() {
          final String? error = controller.errorMessage.value;
          if (error == null) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(bottom: 16.sz),
            child: AppInlineMessage(message: error),
          );
        }),
        Container(
          padding: EdgeInsets.all(18.sz),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20.sz),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 68.sz,
                height: 68.sz,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.document_scanner_rounded,
                  size: 32.sz,
                  color: scheme.primary,
                ),
              ),
              14.vSpace,
              Text(
                ScanStrings.heroTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              6.vSpace,
              Text(
                ScanStrings.heroDesc,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              18.vSpace,
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: ScanStrings.takePhoto,
                      icon: Icons.photo_camera_rounded,
                      onPressed: () =>
                          controller.pickImage(ImageSource.camera),
                    ),
                  ),
                  12.hSpace,
                  Expanded(
                    child: AppButton(
                      label: ScanStrings.fromGallery,
                      icon: Icons.photo_library_rounded,
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          controller.pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        20.vSpace,
        const _TipsCard(),
      ],
    );
  }
}

/// Short list of photo tips.
class _TipsCard extends StatelessWidget {
  const _TipsCard();

  static const List<String> _tips = <String>[
    ScanStrings.tip1,
    ScanStrings.tip2,
    ScanStrings.tip3,
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ScanStrings.tipsTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          10.vSpace,
          for (final String tip in _tips)
            Padding(
              padding: EdgeInsets.only(bottom: 8.sz),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18.sz,
                    color: scheme.primary,
                  ),
                  10.hSpace,
                  Expanded(
                    child: Text(
                      tip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
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

/// Step 2: image with a scanning line while the model works.
class _AnalyzingView extends StatelessWidget {
  const _AnalyzingView({required this.controller});

  final PatientScanController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        ScanPreviewCard(
          imagePath: controller.imagePath.value,
          isScanning: true,
          height: 280,
        ),
        24.vSpace,
        Text(
          ScanStrings.analyzingTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        6.vSpace,
        Text(
          ScanStrings.analyzingDesc,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        18.vSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(6.sz),
          child: SizedBox(
            width: 180.sz,
            child: LinearProgressIndicator(
              minHeight: 5.sz,
              color: theme.colorScheme.primary,
              backgroundColor:
              theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 3: AI result (with heatmap toggle) and the next actions.
class _ResultView extends StatelessWidget {
  const _ResultView({required this.controller});

  final PatientScanController controller;

  @override
  Widget build(BuildContext context) {
    final ScanResultModel? result = controller.result.value;
    if (result == null) return const SizedBox.shrink();

    final bool isLow = result.risk == RiskLevel.low;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Original + AI heatmap with a switch (heatmap is optional).
        ScanImageViewer(
          originalPath: controller.imagePath.value,
          heatmapPath: result.heatmapPath,
          height: 210,
        ),
        16.vSpace,
        AiResultCard(result: result),
        14.vSpace,
        AppInlineMessage(
          message: isLow ? ScanStrings.lowRiskHint : ScanStrings.highRiskHint,
          isError: !isLow,
        ),
        20.vSpace,
        AppButton(
          label: ScanStrings.sendToDoctor,
          icon: Icons.send_rounded,
          onPressed: controller.sendToDoctor,
        ),
        12.vSpace,
        AppButton(
          label: ScanStrings.scanAnother,
          icon: Icons.refresh_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: controller.reset,
        ),
      ],
    );
  }
}