import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/responsive/responsive_wrapper.dart';
import 'package:retina_scan_app/res/routes/app_pages.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:retina_scan_app/res/services/data_service.dart';
import 'package:retina_scan_app/res/services/permission_service.dart';
import 'package:retina_scan_app/res/services/scan_analysis_service.dart';
import 'package:retina_scan_app/res/theme/app_theme.dart';
import 'package:retina_scan_app/res/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Permanent services — created once and never disposed.
  // Order matters: each service uses the ones above it.
  Get.put<ApiClient>(ApiClient(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<DataService>(DataService(), permanent: true);
  Get.put<ScanAnalysisService>(ScanAnalysisService(), permanent: true);
  Get.put<PermissionService>(PermissionService(), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const RetinaScanApp());
}

/// Root widget of the app.
class RetinaScanApp extends StatelessWidget {
  const RetinaScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Get.find<ThemeController>();

    return Obx(
          () => GetMaterialApp(
        title: 'Retina Scan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // Theme follows the saved user choice (Light / Dark / System).
        themeMode: theme.mode.value,
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: AppPages.transitionDuration,
        builder: (BuildContext context, Widget? child) {
          return ResponsiveWrapper(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}