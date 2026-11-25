import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/shared/base_reports_controller.dart';

/// Logic of the patient My Reports tab.
class PatientReportsController extends BaseReportsController {
  @override
  List<ReportFilter> get filters => ReportFilter.values;

  @override
  List<ReportModel> get sourceReports => data.reportsOfPatient(myId);
}