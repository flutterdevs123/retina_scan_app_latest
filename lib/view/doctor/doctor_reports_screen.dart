import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/res/components/app_filter_chips.dart';
import 'package:retina_scan_app/res/components/report_card_list.dart';
import 'package:retina_scan_app/res/components/tab_header.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_reports_controller.dart';

/// Doctor Reports tab: accepted and rejected reports with a filter.
class DoctorReportsScreen extends GetView<DoctorReportsController> {
  const DoctorReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        const TabHeader(
          title: AppStrings.doctorReportsTitle,
          subtitle: AppStrings.doctorReportsSubtitle,
        ),
        20.vSpace,
        Obx(
              () => AppFilterChips<ReportFilter>(
            options: controller.filters,
            selected: controller.filter.value,
            labelOf: (ReportFilter f) => f.label,
            onSelected: controller.setFilter,
          ),
        ),
        16.vSpace,
        Obx(
              () => ReportCardList(
            reports: controller.visibleReports,
            titleOf: (ReportModel r) => r.patientName,
            onTap: controller.openReport,
          ),
        ),
      ],
    );
  }
}