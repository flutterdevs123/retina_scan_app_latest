import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the doctor Requests tab (reports waiting for review).
class DoctorRequestsController extends BaseUserController {
  /// Pending reports, newest first.
  List<ReportModel> get pendingReports => data
      .reportsOfDoctor(myId)
      .where((ReportModel r) => r.status == ReportStatus.pending)
      .toList();
}