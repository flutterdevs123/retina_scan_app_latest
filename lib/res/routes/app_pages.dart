import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/routes/role_middleware.dart';
import 'package:retina_scan_app/view/doctor/doctor_shell_screen.dart';
import 'package:retina_scan_app/view/doctor/patient_history_screen.dart';
import 'package:retina_scan_app/view/forgot_password_screen.dart';
import 'package:retina_scan_app/view/login_screen.dart';
import 'package:retina_scan_app/view/onboarding_screen.dart';
import 'package:retina_scan_app/view/patient/create_request_screen.dart';
import 'package:retina_scan_app/view/patient/patient_shell_screen.dart';
import 'package:retina_scan_app/view/patient/select_doctor_screen.dart';
import 'package:retina_scan_app/view/shared/notifications_screen.dart';
import 'package:retina_scan_app/view/shared/report_detail_screen.dart';
import 'package:retina_scan_app/view/signup_screen.dart';
import 'package:retina_scan_app/view/splash_screen.dart';
import 'package:retina_scan_app/view/verify_email_screen.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_home_controller.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_patients_controller.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_reports_controller.dart';
import 'package:retina_scan_app/view_models/doctor/doctor_requests_controller.dart';
import 'package:retina_scan_app/view_models/doctor/patient_history_controller.dart';
import 'package:retina_scan_app/view_models/forgot_password_controller.dart';
import 'package:retina_scan_app/view_models/login_controller.dart';
import 'package:retina_scan_app/view_models/onboarding_controller.dart';
import 'package:retina_scan_app/view_models/patient/create_request_controller.dart';
import 'package:retina_scan_app/view_models/patient/patient_home_controller.dart';
import 'package:retina_scan_app/view_models/patient/patient_reports_controller.dart';
import 'package:retina_scan_app/view_models/patient/patient_scan_controller.dart';
import 'package:retina_scan_app/view_models/patient/select_doctor_controller.dart';
import 'package:retina_scan_app/view_models/shared/main_shell_controller.dart';
import 'package:retina_scan_app/view_models/shared/notifications_controller.dart';
import 'package:retina_scan_app/view_models/shared/profile_controller.dart';
import 'package:retina_scan_app/view_models/shared/report_detail_controller.dart';
import 'package:retina_scan_app/view_models/signup_controller.dart';
import 'package:retina_scan_app/view_models/splash_controller.dart';
import 'package:retina_scan_app/view_models/verify_email_controller.dart';

/// Maps every route name to its screen and controller binding.
class AppPages {
  AppPages._();

  /// First route shown when the app starts.
  static const String initial = AppRoutes.splash;

  /// Short duration so screen changes feel instant.
  static const Duration transitionDuration = Duration(milliseconds: 200);

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    // -------------------------------------------------------------------------
    // Auth flow
    // -------------------------------------------------------------------------
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      // Controller is created only when the screen opens.
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<OnboardingController>(() => OnboardingController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.signUp,
      page: () => const SignupScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<SignupController>(() => SignupController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.verifyEmail,
      page: () => const VerifyEmailScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<VerifyEmailController>(() => VerifyEmailController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<ForgotPasswordController>(
              () => ForgotPasswordController(),
        );
      }),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Dashboards: RoleMiddleware blocks users with the wrong role.
    // Every tab controller of the dashboard is registered here.
    // -------------------------------------------------------------------------
    GetPage<dynamic>(
      name: AppRoutes.doctorDashboard,
      page: () => const DoctorShellScreen(),
      middlewares: <GetMiddleware>[RoleMiddleware(UserRole.doctor)],
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<MainShellController>(() => MainShellController());
        Get.lazyPut<DoctorHomeController>(() => DoctorHomeController());
        Get.lazyPut<DoctorRequestsController>(
              () => DoctorRequestsController(),
        );
        Get.lazyPut<DoctorReportsController>(() => DoctorReportsController());
        Get.lazyPut<DoctorPatientsController>(
              () => DoctorPatientsController(),
        );
        Get.lazyPut<ProfileController>(() => ProfileController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.patientDashboard,
      page: () => const PatientShellScreen(),
      middlewares: <GetMiddleware>[RoleMiddleware(UserRole.patient)],
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<MainShellController>(() => MainShellController());
        Get.lazyPut<PatientHomeController>(() => PatientHomeController());
        Get.lazyPut<PatientScanController>(() => PatientScanController());
        Get.lazyPut<PatientReportsController>(
              () => PatientReportsController(),
        );
        Get.lazyPut<ProfileController>(() => ProfileController());
      }),
      transition: Transition.fadeIn,
    ),

    // -------------------------------------------------------------------------
    // Screens opened on top of a dashboard
    // -------------------------------------------------------------------------
    GetPage<dynamic>(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<NotificationsController>(() => NotificationsController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.reportDetail,
      page: () => const ReportDetailScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<ReportDetailController>(() => ReportDetailController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.patientHistory,
      page: () => const PatientHistoryScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<PatientHistoryController>(
              () => PatientHistoryController(),
        );
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.selectDoctor,
      page: () => const SelectDoctorScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<SelectDoctorController>(() => SelectDoctorController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.createRequest,
      page: () => const CreateRequestScreen(),
      binding: BindingsBuilder<dynamic>(() {
        Get.lazyPut<CreateRequestController>(() => CreateRequestController());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}