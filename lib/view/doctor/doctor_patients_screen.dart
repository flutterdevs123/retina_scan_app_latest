import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/components/app_search_field.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/person_tile.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/tab_header.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_patients_controller.dart';

/// Doctor Patients tab: own patient files, or search any patient by name / ID.
class DoctorPatientsScreen extends GetView<DoctorPatientsController> {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        const TabHeader(
          title: AppStrings.patientsTitle,
          subtitle: AppStrings.patientsSubtitle,
        ),
        20.vSpace,
        AppSearchField(
          controller: controller.searchController,
          hint: AppStrings.searchPatientsHint,
          onChanged: controller.onQueryChanged,
        ),
        20.vSpace,
        Obx(
              () => SectionTitle(
            title: controller.isSearching
                ? AppStrings.searchResults
                : AppStrings.myPatientFiles,
          ),
        ),
        12.vSpace,
        Obx(() {
          final List<UserModel> patients = controller.patients;
          if (patients.isEmpty) {
            return const EmptyState(
              icon: Icons.person_search_rounded,
              title: AppStrings.noPatientsTitle,
              message: AppStrings.noPatientsMsg,
            );
          }
          return Column(
            children: <Widget>[
              for (final UserModel patient in patients)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.sz),
                  child: PersonTile(
                    name: patient.name,
                    id: patient.id,
                    subtitle: AppStrings.reportsCount(
                      controller.reportCountOf(patient.id),
                    ),
                    onTap: () => controller.openPatient(patient),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}