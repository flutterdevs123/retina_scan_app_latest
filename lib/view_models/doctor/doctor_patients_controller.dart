import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the doctor Patients tab: patient files and patient search.
class DoctorPatientsController extends BaseUserController {
  final TextEditingController searchController = TextEditingController();

  /// Current search text.
  final RxString query = ''.obs;

  /// True while the user is searching.
  bool get isSearching => query.value.trim().isNotEmpty;

  /// Search results across all patients, or this doctor's own patient files
  /// when the search box is empty.
  List<UserModel> get patients => isSearching
      ? data.searchUsers(UserRole.patient, query.value)
      : data.patientsOfDoctor(myId);

  /// Called when the search text changes.
  void onQueryChanged(String value) => query.value = value;

  /// How many reports [patientId] has sent to this doctor.
  int reportCountOf(String patientId) => data.historyOf(patientId, myId).length;

  /// Opens the medical history of [patient].
  void openPatient(UserModel patient) =>
      Get.toNamed(AppRoutes.patientHistory, arguments: patient.id);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}