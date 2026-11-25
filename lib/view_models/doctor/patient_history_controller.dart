import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the patient medical history screen (doctor side).
class PatientHistoryController extends BaseUserController {
  /// ID of the patient, passed as a route argument.
  late final String patientId;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    patientId = args is String ? args : '';
  }

  /// The patient (null if the ID is unknown).
  UserModel? get patient => data.userById(patientId);

  /// Every report this patient sent to the logged in doctor, reviewed or not.
  List<ReportModel> get history => data.historyOf(patientId, myId);

  /// Number of history reports with the given [status].
  int countOf(ReportStatus status) =>
      history.where((ReportModel r) => r.status == status).length;
}