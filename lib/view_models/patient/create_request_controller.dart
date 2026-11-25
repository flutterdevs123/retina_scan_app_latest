import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/create_request_args.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/utils/form_controller_mixin.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';
import 'package:retina_scan_app/view_models/patient/patient_scan_controller.dart';

/// Sends the scan and the patient's story to the chosen doctor.
class CreateRequestController extends BaseUserController
    with FormControllerMixin {
  /// Index of the My Reports tab in the patient dashboard.
  static const int _reportsTabIndex = 2;

  late final UserModel? doctor;
  late final ScanResultModel? scan;

  final TextEditingController symptomsController = TextEditingController();

  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  @override
  List<TextEditingController> get textControllers =>
      <TextEditingController>[symptomsController];

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is CreateRequestArgs) {
      doctor = data.userById(args.doctorId);
      scan = args.scan;
    } else {
      doctor = null;
      scan = null;
    }
  }

  /// Adds a quick symptom to the end of the story.
  void addSymptom(String symptom) {
    final String current = symptomsController.text.trim();
    final String next = current.isEmpty ? '$symptom. ' : '$current $symptom. ';
    symptomsController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }

  Future<void> submit() async {
    closeKeyboard();
    if (isLoading.value || !validateForm()) return;

    final UserModel? receiver = doctor;
    final ScanResultModel? attached = scan;
    if (receiver == null || attached == null) {
      errorMessage.value = ApiStrings.errNoScan;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    try {
      await data.submitScan(
        scanId: attached.scanId,
        doctor: receiver,
        notes: symptomsController.text.trim(),
      );

      // Close "choose doctor" and this screen, back to the dashboard.
      Get.until(
            (Route<dynamic> route) =>
        route.settings.name == AppRoutes.patientDashboard,
      );
      // Next scan starts from a clean state.
      if (Get.isRegistered<PatientScanController>()) {
        Get.find<PatientScanController>().reset();
      }
      goToTab(_reportsTabIndex);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    symptomsController.dispose();
    super.onClose();
  }
}