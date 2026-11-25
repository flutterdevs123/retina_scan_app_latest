import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the patient Home tab.
class PatientHomeController extends BaseUserController {
  /// Index of the Scan and My Reports tabs in the patient dashboard.
  static const int _scanTabIndex = 1;
  static const int _reportsTabIndex = 2;

  List<ReportModel> get _myReports => data.reportsOfPatient(myId);

  int _count(ReportStatus status) =>
      _myReports.where((ReportModel r) => r.status == status).length;

  int get totalCount => _myReports.length;
  int get pendingCount => _count(ReportStatus.pending);
  int get acceptedCount => _count(ReportStatus.accepted);
  int get rejectedCount => _count(ReportStatus.rejected);

  /// Latest three reports.
  List<ReportModel> get recentReports => _myReports.take(3).toList();

  /// Opens the Scan tab.
  void goToScan() => goToTab(_scanTabIndex);

  /// Opens the My Reports tab.
  void goToReports() => goToTab(_reportsTabIndex);
}