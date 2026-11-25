import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/shared/base_reports_controller.dart';

/// Logic of the doctor Reports tab: reports that are already reviewed.
class DoctorReportsController extends BaseReportsController {
  @override
  List<ReportFilter> get filters => const <ReportFilter>[
    ReportFilter.all,
    ReportFilter.accepted,
    ReportFilter.rejected,
  ];

  @override
  List<ReportModel> get sourceReports => data
      .reportsOfDoctor(myId)
      .where((ReportModel r) => r.status != ReportStatus.pending)
      .toList();
}