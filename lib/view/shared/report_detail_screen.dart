import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/res/components/ai_result_card.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/app_filter_chips.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/app_inner_scaffold.dart';
import 'package:retina_scan_app/res/components/app_text_field.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/info_row.dart';
import 'package:retina_scan_app/res/components/scan_image_viewer.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/status_badge.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/date_formatter.dart';
import 'package:retina_scan_app/view_models/shared/report_detail_controller.dart';

/// Full details of one report: image + heatmap, AI analysis, story, doctor's
/// decision. Doctors get the review form; patients get send / delete for drafts.
class ReportDetailScreen extends GetView<ReportDetailController> {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ReportModel? report = controller.report;

      if (report == null) {
        return const AppInnerScaffold(
          title: AppStrings.reportDetailsTitle,
          children: <Widget>[
            EmptyState(
              icon: Icons.search_off_rounded,
              title: AppStrings.reportNotFound,
              message: AppStrings.reportNotFoundMsg,
            ),
          ],
        );
      }

      Widget? bottom;
      if (controller.canReview) {
        bottom = _ReviewActions(controller: controller);
      } else if (controller.canSend) {
        bottom = _DraftActions(controller: controller);
      }

      return AppInnerScaffold(
        title: AppStrings.reportDetailsTitle,
        bottom: bottom,
        children: _buildContent(context, report),
      );
    });
  }

  List<Widget> _buildContent(BuildContext context, ReportModel report) {
    final ThemeData theme = Theme.of(context);
    final bool isDoctor = controller.isDoctor;
    final bool isDraft = report.status == ReportStatus.draft;

    return <Widget>[
      _SummaryCard(report: report),
      16.vSpace,
      ScanImageViewer(
        originalPath: report.scan?.imagePath,
        heatmapPath: report.scan?.heatmapPath,
        height: 210,
      ),
      if (report.scan != null) ...<Widget>[
        16.vSpace,
        const SectionTitle(title: ScanStrings.aiAnalysis),
        10.vSpace,
        AiResultCard(result: report.scan!),
      ],
      20.vSpace,
      AppCard(
        child: Column(
          children: <Widget>[
            InfoRow(
              icon: isDoctor
                  ? Icons.person_outline_rounded
                  : Icons.medical_services_outlined,
              label: isDoctor ? AppStrings.labelPatient : AppStrings.labelDoctor,
              value: isDoctor
                  ? '${report.patientName} (${report.patientId})'
                  : (isDraft
                  ? ApiStrings.notSent
                  : '${report.doctorName} (${report.doctorId})'),
            ),
            16.vSpace,
            InfoRow(
              icon: Icons.event_rounded,
              label: isDraft ? ApiStrings.labelScanned : AppStrings.labelSubmitted,
              value: DateFormatter.withTime(report.sortDate),
            ),
            if (report.reviewedAt != null) ...<Widget>[
              16.vSpace,
              InfoRow(
                icon: Icons.event_available_rounded,
                label: AppStrings.labelReviewed,
                value: DateFormatter.withTime(report.reviewedAt!),
              ),
            ],
            if (report.doctorGrade != null) ...<Widget>[
              16.vSpace,
              InfoRow(
                icon: Icons.rate_review_outlined,
                label: ApiStrings.doctorGradeLabel,
                value: report.doctorGrade!,
              ),
            ],
            if (report.finalGrade != null &&
                report.status != ReportStatus.draft) ...<Widget>[
              16.vSpace,
              InfoRow(
                icon: Icons.flag_outlined,
                label: ApiStrings.finalGradeLabel,
                value: report.finalGrade!,
              ),
            ],
          ],
        ),
      ),
      if (report.symptoms.isNotEmpty) ...<Widget>[
        20.vSpace,
        const SectionTitle(title: AppStrings.symptomsTitle),
        10.vSpace,
        AppCard(
          child: Text(
            report.symptoms,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
      if (report.doctorNote.isNotEmpty) ...<Widget>[
        20.vSpace,
        const SectionTitle(title: AppStrings.doctorNoteTitle),
        10.vSpace,
        AppCard(
          child: Text(
            report.doctorNote,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
      if (!isDoctor && report.status == ReportStatus.pending) ...<Widget>[
        20.vSpace,
        const _WaitingCard(),
      ],
      if (isDoctor) ...<Widget>[
        20.vSpace,
        AppButton(
          label: AppStrings.viewPatientHistory,
          icon: Icons.history_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: controller.openPatientHistory,
        ),
      ],
      // Review form sirf doctor ko dikhega jab report pending ho
      if (controller.canReview) ...<Widget>[
        24.vSpace,
        SectionTitle(title: ApiStrings.yourGrade),
        10.vSpace,
        Obx(
              () => AppFilterChips<String>(
            options: <String>['', ...ApiStrings.grades],
            selected: controller.selectedGrade.value ?? '',
            labelOf: (String o) => o.isEmpty ? ApiStrings.sameAsAi : o,
            onSelected: (String o) => controller.setGrade(o.isEmpty ? null : o),
          ),
        ),
        16.vSpace,
        Form(
          key: controller.formKey,
          child: AppTextField(
            controller: controller.noteController,
            label: AppStrings.noteLabel,
            hint: AppStrings.noteHint,
            prefixIcon: Icons.notes_rounded,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            validator: controller.noteValidator,
          ),
        ),
      ],
      Obx(() {
        final String? error = controller.errorMessage.value;
        if (error == null) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(top: 16.sz),
          child: AppInlineMessage(message: error),
        );
      }),
    ];
  }
}

/// Report ID and status at the top.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.report});

  final ReportModel report;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = StatusBadge.colorOf(report.status, theme.colorScheme);

    return AppCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 48.sz,
            height: 48.sz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.sz),
              color: color.withValues(alpha: 0.14),
            ),
            child: Icon(report.status.icon, size: 26.sz, color: color),
          ),
          14.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  report.id,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                6.vSpace,
                StatusBadge(status: report.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info card for patients while the doctor has not decided yet.
class _WaitingCard extends StatelessWidget {
  const _WaitingCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppCard(
      child: Row(
        children: <Widget>[
          Icon(Icons.hourglass_top_rounded, size: 22.sz, color: theme.colorScheme.primary),
          12.hSpace,
          Expanded(
            child: Text(
              AppStrings.waitingReview,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reject and Accept buttons pinned at the bottom (doctor only).
class _ReviewActions extends StatelessWidget {
  const _ReviewActions({required this.controller});

  final ReportDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool busy = controller.isBusy.value;
      return Row(
        children: <Widget>[
          Expanded(
            child: AppButton(
              label: AppStrings.reject,
              icon: Icons.close_rounded,
              variant: AppButtonVariant.danger,
              onPressed: busy ? null : controller.reject,
            ),
          ),
          12.hSpace,
          Expanded(
            child: AppButton(
              label: AppStrings.accept,
              icon: Icons.check_rounded,
              isLoading: busy,
              onPressed: controller.accept,
            ),
          ),
        ],
      );
    });
  }
}

/// Send / delete buttons for a scan the patient has not sent yet.
class _DraftActions extends StatelessWidget {
  const _DraftActions({required this.controller});

  final ReportDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool busy = controller.isBusy.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppButton(
            label: ScanStrings.sendToDoctor,
            icon: Icons.send_rounded,
            onPressed: busy ? null : controller.sendToDoctor,
          ),
          10.vSpace,
          AppButton(
            label: ApiStrings.deleteScan,
            icon: Icons.delete_outline_rounded,
            variant: AppButtonVariant.danger,
            isLoading: busy,
            onPressed: controller.deleteDraft,
          ),
        ],
      );
    });
  }
}