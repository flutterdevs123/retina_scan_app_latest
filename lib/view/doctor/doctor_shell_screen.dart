import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_bottom_nav_bar.dart';
import 'package:retina_scan_app/res/components/app_shell.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/view/doctor/doctor_home_screen.dart';
import 'package:retina_scan_app/view/doctor/doctor_patients_screen.dart';
import 'package:retina_scan_app/view/doctor/doctor_reports_screen.dart';
import 'package:retina_scan_app/view/doctor/doctor_requests_screen.dart';
import 'package:retina_scan_app/view/shared/profile_screen.dart';
import 'package:retina_scan_app/view_models/shared/main_shell_controller.dart';

/// Doctor dashboard frame: bottom navigation + tabs.
/// To add or remove a tab, edit BOTH lists below (same order).
class DoctorShellScreen extends GetView<MainShellController> {
  const DoctorShellScreen({super.key});

  static const List<NavItem> _items = <NavItem>[
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: AppStrings.navHome,
    ),
    NavItem(
      icon: Icons.inbox_outlined,
      activeIcon: Icons.inbox_rounded,
      label: AppStrings.navRequests,
    ),
    NavItem(
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check_rounded,
      label: AppStrings.navReports,
    ),
    NavItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: AppStrings.navPatients,
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: AppStrings.navProfile,
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    DoctorHomeScreen(),
    DoctorRequestsScreen(),
    DoctorReportsScreen(),
    DoctorPatientsScreen(),
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