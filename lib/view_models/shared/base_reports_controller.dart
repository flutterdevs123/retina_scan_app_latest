import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Filtering logic shared by the doctor and patient report lists (DRY).
/// A child only says which reports exist and which filters are offered.
abstract class BaseReportsController extends BaseUserController {
  /// Currently selected filter chip.
  final Rx<ReportFilter> filter = ReportFilter.all.obs;

  /// Filter chips offered on the screen.
  List<ReportFilter> get filters;

  /// All reports this screen is allowed to show (before filtering).
  List<ReportModel> get sourceReports;

  /// Reports that match the selected filter.
  List<ReportModel> get visibleReports => sourceReports
      .where((ReportModel r) => filter.value.matches(r.status))
      .toList();

  /// Called when a chip is tapped.
  void setFilter(ReportFilter value) => filter.value = value;
}