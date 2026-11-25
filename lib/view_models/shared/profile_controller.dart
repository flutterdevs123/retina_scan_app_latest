import 'package:get/get.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the Profile tab (same for doctor and patient).
class ProfileController extends BaseUserController {
  /// Logs out on the server, clears the session and opens login.
  Future<void> logout() async {
    // Next login must start on the Home tab.
    goToTab(0);
    await auth.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}