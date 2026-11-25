import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_bottom_nav_bar.dart';
import 'package:retina_scan_app/res/components/app_shell.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/view/patient/patient_home_screen.dart';
import 'package:retina_scan_app/view/patient/patient_reports_screen.dart';
import 'package:retina_scan_app/view/patient/patient_scan_screen.dart';
import 'package:retina_scan_app/view/shared/profile_screen.dart';
import 'package:retina_scan_app/view_models/shared/main_shell_controller.dart';

/// Patient dashboard frame: bottom navigation + tabs.
/// To add or remove a tab, edit BOTH lists below (same order).
class PatientShellScreen extends GetView<MainShellController> {
  const PatientShellScreen({super.key});

  static const List<NavItem> _items = <NavItem>[
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: AppStrings.navHome,
    ),
    NavItem(
      icon: Icons.document_scanner_outlined,
      activeIcon: Icons.document_scanner_rounded,
      label: ScanStrings.navScan,
    ),
    NavItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description_rounded,
      label: AppStrings.navMyReports,
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: AppStrings.navProfile,
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    PatientHomeScreen(),
    PatientScanScreen(),
    PatientReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      items: _items,
      pages: _pages,
      currentIndex: controller.currentIndex,
      onTap: controller.setIndex,
    );
  }
}