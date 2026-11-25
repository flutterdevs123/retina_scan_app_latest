import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/res/components/notification_bell.dart';
import 'package:retina_scan_app/res/components/report_card_list.dart';
import 'package:retina_scan_app/res/components/tab_header.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_requests_controller.dart';

/// Doctor Requests tab: reports waiting for accept / reject.
class DoctorRequestsScreen extends GetView<DoctorRequestsController> {
  const DoctorRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        Obx(
              () => TabHeader(
            title: AppStrings.requestsTitle,
            subtitle: AppStrings.requestsSubtitle,
            trailing: NotificationBell(
              count: controller.unreadCount,
              onPressed: controller.openNotifications,
            ),
          ),
        ),
        20.vSpace,
        Obx(
              () => ReportCardList(
            reports: controller.pendingReports,
            titleOf: (ReportModel r) => r.patientName,
            onTap: controller.openReport,
            emptyTitle: AppStrings.emptyRequestsTitle,
            emptyMessage: AppStrings.emptyRequestsMsg,
          ),
        ),
      ],
    );
  }
}