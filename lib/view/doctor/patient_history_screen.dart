import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/components/app_avatar.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/app_inner_scaffold.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/report_card_list.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/stat_grid.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/doctor/patient_history_controller.dart';

/// Medical history file of one patient (all reports sent to this doctor).
class PatientHistoryScreen extends GetView<PatientHistoryController> {
  const PatientHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final UserModel? patient = controller.patient;

      if (patient == null) {
        return const AppInnerScaffold(
          title: AppStrings.patientHistoryTitle,
          children: <Widget>[
            EmptyState(
              icon: Icons.person_off_outlined,
              title: AppStrings.patientNotFound,
              message: AppStrings.patientNotFoundMsg,
            ),
          ],
        );
      }

      final List<ReportModel> history = controller.history;

      return AppInnerScaffold(
        title: AppStrings.patientHistoryTitle,
        children: <Widget>[
          _PatientCard(patient: patient),
          20.vSpace,
          StatGrid(
            items: <StatItem>[
              StatItem(
                icon: Icons.folder_open_rounded,
                value: '${history.length}',
                label: AppStrings.statTotalReports,
              ),
              StatItem(
                icon: Icons.pending_actions_rounded,
                value: '${controller.countOf(ReportStatus.pending)}',
                label: AppStrings.statNotReviewed,
              ),
              StatItem(
                icon: Icons.check_circle_outline_rounded,
                value: '${controller.countOf(ReportStatus.accepted)}',
                label: AppStrings.statAccepted,
              ),
              StatItem(
                icon: Icons.cancel_outlined,
                value: '${controller.countOf(ReportStatus.rejected)}',
                label: AppStrings.statRejected,
              ),
            ],
          ),
          28.vSpace,
          const SectionTitle(title: AppStrings.medicalHistory),
          12.vSpace,
          ReportCardList(
            reports: history,
            titleOf: (ReportModel r) => AppStrings.retinaScanReport,
            onTap: controller.openReport,
            emptyTitle: AppStrings.noHistoryTitle,
            emptyMessage: AppStrings.noHistoryMsg,
          ),
        ],
      );
    });
  }
}

/// Patient avatar, name and ID.
///
/// The backend does not expose email / phone / age, so only these three
/// are shown. If they become available later, add more InfoRow widgets.
class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});

  final UserModel patient;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppCard(
      child: Row(
        children: <Widget>[
          AppAvatar(initials: patient.initials, size: 64),
          14.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  patient.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.vSpace,
                Text(
                  patient.id,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
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