import 'package:retina_scan_app/models/user_role.dart';

/// Route names only. Every new screen adds one constant here.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';

  // Dashboards (protected by RoleMiddleware).
  static const String doctorDashboard = '/doctor-dashboard';
  static const String patientDashboard = '/patient-dashboard';

  // Screens opened on top of a dashboard.
  static const String notifications = '/notifications';
  static const String reportDetail = '/report-detail';
  static const String patientHistory = '/patient-history';
  static const String selectDoctor = '/select-doctor';
  static const String createRequest = '/create-request';

  // NOTE: editProfile removed - backend has no PATCH /auth/me endpoint.
  // NOTE: verifyEmail screen kept for UI only (backend has no email verification).

  /// Returns the dashboard route that belongs to [role].
  static String dashboardFor(UserRole role) {
    switch (role) {
      case UserRole.doctor:
        return doctorDashboard;
      case UserRole.patient:
        return patientDashboard;
    }
  }
}