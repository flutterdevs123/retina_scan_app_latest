import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/components/app_inner_scaffold.dart';
import 'package:retina_scan_app/res/components/app_search_field.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/person_tile.dart';
import 'package:retina_scan_app/res/components/scan_summary_tile.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/patient/select_doctor_controller.dart';

/// Lets the patient find a doctor by name, ID or specialty.
class SelectDoctorScreen extends GetView<SelectDoctorController> {
  const SelectDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInnerScaffold(
      title: ScanStrings.chooseDoctorTitle,
      children: <Widget>[
        if (controller.scan != null) ...<Widget>[
          const SectionTitle(title: ScanStrings.attachedScan),
          10.vSpace,
          ScanSummaryTile(result: controller.scan!),
          20.vSpace,
        ],
        AppSearchField(
          controller: controller.searchController,
          hint: AppStrings.searchDoctorsHint,
          onChanged: controller.onQueryChanged,
        ),
        20.vSpace,
        Obx(
              () => SectionTitle(
            title: controller.isSearching
                ? AppStrings.searchResults
                : AppStrings.availableDoctors,
          ),
        ),
        12.vSpace,
        Obx(() {
          final List<UserModel> doctors = controller.doctors;
          if (doctors.isEmpty) {
            return const EmptyState(
              icon: Icons.person_search_rounded,
              title: AppStrings.noDoctorsTitle,
              message: AppStrings.noDoctorsMsg,
            );
          }
          return Column(
            children: <Widget>[
              for (final UserModel doctor in doctors)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.sz),
                  child: PersonTile(
                    name: doctor.name,
                    id: doctor.id,
                    subtitle: doctor.specialty,
                    onTap: () => controller.openDoctor(doctor),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}