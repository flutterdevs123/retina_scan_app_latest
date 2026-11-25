import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/utils/form_controller_mixin.dart';
import 'package:retina_scan_app/res/utils/validators.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the report detail screen.
/// Doctors can approve / reject pending reports. Patients can send or delete
/// their draft scans.
class ReportDetailController extends BaseUserController
    with FormControllerMixin {
  late final String reportId;

  final TextEditingController noteController = TextEditingController();

  /// Grade chosen by the doctor (null = same as the AI).
  final Rxn<String> selectedGrade = Rxn<String>();

  /// True while a request is running.
  final RxBool isBusy = false.obs;

  final Rxn<String> errorMessage = Rxn<String>();

  /// When true the note is mandatory (used while rejecting).
  bool _requireNote = false;

  @override
  List<TextEditingController> get textControllers =>
      <TextEditingController>[noteController];

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    reportId = args is String ? args : '';
    // Load the latest version of this report from the server.
    data.fetchReport(reportId);
  }

  ReportModel? get report => data.reportById(reportId);

  bool get isDoctor => user?.role == UserRole.doctor;

  /// Doctor can still decide on this report.
  bool get canReview {
    final ReportModel? r = report;
    return isDoctor &&
        r != null &&
        r.status == ReportStatus.pending &&
        r.doctorId == myId;
  }

  /// Patient can send this unsent scan to a doctor.
  bool get canSend {
    final ReportModel? r = report;
    return !isDoctor &&
        r != null &&
        r.status == ReportStatus.draft &&
        r.patientId == myId;
  }

  void setGrade(String? grade) => selectedGrade.value = grade;

  /// Note validator: required only when rejecting.
  String? noteValidator(String? value) {
    if (!_requireNote) return null;
    return Validators.requiredText(value, AppStrings.errReasonRequired);
  }

  Future<void> accept() => _review(accepted: true);

  Future<void> reject() => _review(accepted: false);

  void openPatientHistory() {
    final ReportModel? r = report;
    if (r == null) return;
    Get.toNamed(AppRoutes.patientHistory, arguments: r.patientId);
  }

  /// Opens the doctor list with this scan attached.
  void sendToDoctor() {
    final ReportModel? r = report;
    if (r?.scan == null) return;
    Get.toNamed(AppRoutes.selectDoctor, arguments: r!.scan);
  }

  Future<void> deleteDraft() async {
    if (isBusy.value) return;
    isBusy.value = true;
    errorMessage.value = null;
    try {
      await data.deleteDraft(reportId);
      Get.back();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isBusy.value = false;
    }
  }

  /// Shared accept / reject logic.
  Future<void> _review({required bool accepted}) async {
    closeKeyboard();
    if (isBusy.value) return;

    _requireNote = !accepted;
    final bool isValid = validateForm();
    _requireNote = false;
    if (!isValid) return;

    isBusy.value = true;
    errorMessage.value = null;
    try {
      await data.reviewReport(
        reportId: reportId,
        accepted: accepted,
        note: noteController.text,
        doctorGrade: selectedGrade.value,
      );
      Get.back(); // Go back to the Requests list after success
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isBusy.value = false;
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}