import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the doctor Home tab.
class DoctorHomeController extends BaseUserController {
  /// Index of the Requests tab in the doctor dashboard.
  static const int _requestsTabIndex = 1;

  List<ReportModel> get _myReports => data.reportsOfDoctor(myId);

  int _count(ReportStatus status) =>
      _myReports.where((ReportModel r) => r.status == status).length;

  int get pendingCount => _count(ReportStatus.pending);
  int get acceptedCount => _count(ReportStatus.accepted);
  int get rejectedCount => _count(ReportStatus.rejected);

  /// Number of patients who have a file with this doctor.
  int get patientCount => data.patientsOfDoctor(myId).length;

  /// Latest three requests that are waiting for a decision.
  List<ReportModel> get recentPending => _myReports
      .where((ReportModel r) => r.status == ReportStatus.pending)
      .take(3)
      .toList();

  /// Opens the Requests tab.
  void goToRequests() => goToTab(_requestsTabIndex);
}