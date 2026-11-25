import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';

/// Role based access control (RBAC) guard for a route.
///
/// - Not logged in            -> redirected to login.
/// - Logged in, wrong role    -> redirected to the user's own dashboard.
/// - Logged in, correct role  -> route opens normally.
class RoleMiddleware extends GetMiddleware {
  RoleMiddleware(this.allowedRole);

  /// The only role allowed to open the protected route.
  final UserRole allowedRole;

  @override
  RouteSettings? redirect(String? route) {
    final user = Get.find<AuthService>().currentUser.value;

    if (user == null) {
      return const RouteSettings(name: AppRoutes.login);
    }
    if (user.role != allowedRole) {
      return RouteSettings(name: AppRoutes.dashboardFor(user.role));
    }
    return null;
  }
}