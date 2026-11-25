import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/create_request_args.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the "choose a doctor" screen: search by name, ID or specialty.
class SelectDoctorController extends BaseUserController {
  final TextEditingController searchController = TextEditingController();

  /// Current search text.
  final RxString query = ''.obs;

  /// Scan result passed from the scan tab.
  late final ScanResultModel? scan;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    scan = args is ScanResultModel ? args : null;
  }

  /// True while the user is searching.
  bool get isSearching => query.value.trim().isNotEmpty;

  /// Doctors that match the search (everyone when the box is empty).
  List<UserModel> get doctors =>
      data.searchUsers(UserRole.doctor, query.value);

  void onQueryChanged(String value) => query.value = value;

  /// Opens the request form for [doctor].
  void openDoctor(UserModel doctor) {
    Get.toNamed(
      AppRoutes.createRequest,
      arguments: CreateRequestArgs(doctorId: doctor.id, scan: scan),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}