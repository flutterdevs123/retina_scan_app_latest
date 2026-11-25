import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/components/dashboard_header.dart';
import 'package:retina_scan_app/res/components/notification_bell.dart';
import 'package:retina_scan_app/res/components/report_card_list.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/stat_card.dart';
import 'package:retina_scan_app/res/components/stat_grid.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/patient/patient_home_controller.dart';

/// Patient Home tab: greeting, stats and latest reports.
class PatientHomeScreen extends GetView<PatientHomeController> {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        Obx(
              () => DashboardHeader(
            name: controller.userName,
            role: UserRole.patient,
            trailing: NotificationBell(
              count: controller.unreadCount,
              onPressed: controller.openNotifications,
            ),
          ),
        ),
        20.vSpace,
        Obx(
              () => StatGrid(
            items: <StatItem>[
              StatItem(
                icon: Icons.folder_open_rounded,
                value: '${controller.totalCount}',
                label: AppStrings.statTotalReports,
              ),
              StatItem(
                icon: Icons.hourglass_top_rounded,
                value: '${controller.pendingCount}',
                label: AppStrings.statPending,
                tone: StatTone.warning,
              ),
              StatItem(
                icon: Icons.check_circle_outline_rounded,
                value: '${controller.acceptedCount}',
                label: AppStrings.statAccepted,
                tone: StatTone.success,
              ),
              StatItem(
                icon: Icons.cancel_outlined,
                value: '${controller.rejectedCount}',
                label: AppStrings.statRejected,
                tone: StatTone.danger,
              ),
            ],
          ),
        ),
        24.vSpace,
        SectionTitle(
          title: AppStrings.recentReports,
          actionLabel: AppStrings.viewAll,
          onAction: controller.goToReports,
        ),
        8.vSpace,
        Obx(
              () => ReportCardList(
            reports: controller.recentReports,
            titleOf: (ReportModel r) => r.doctorName,
            onTap: controller.openReport,
          ),
        ),
      ],
    );
  }
}