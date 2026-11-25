import 'package:get/get.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:retina_scan_app/res/services/data_service.dart';
import 'package:retina_scan_app/view_models/shared/main_shell_controller.dart';

/// Logic shared by every controller that works for the logged in user (DRY).
abstract class BaseUserController extends GetxController {
  final DataService data = Get.find<DataService>();
  final AuthService auth = Get.find<AuthService>();

  /// Logged in user (null only if the session was cleared).
  UserModel? get user => auth.currentUser.value;

  /// ID of the logged in user ('' if nobody is logged in).
  String get myId => user?.id ?? '';

  /// Name of the logged in user.
  String get userName => user?.name ?? '';

  /// Number of unread notifications of the logged in user.
  int get unreadCount => data.unreadCount(myId);

  /// Opens the notifications screen.
  void openNotifications() => Get.toNamed(AppRoutes.notifications);

  /// Opens the detail screen of [report].
  void openReport(ReportModel report) =>
      Get.toNamed(AppRoutes.reportDetail, arguments: report.id);

  /// Switches the dashboard to the tab at [index].
  void goToTab(int index) => Get.find<MainShellController>().setIndex(index);
}