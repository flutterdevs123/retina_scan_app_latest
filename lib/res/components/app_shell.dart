import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_bottom_nav_bar.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';

/// Main frame of a dashboard: background, the visible tab and the bottom bar.
///
/// IndexedStack keeps every tab alive, so switching tabs is instant and the
/// scroll position and search text of each tab are preserved.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.items,
    required this.pages,
    required this.currentIndex,
    required this.onTap,
  });

  /// Bottom bar destinations (same order as [pages]).
  final List<NavItem> items;

  /// Tab screens (same order as [items]).
  final List<Widget> pages;

  /// Selected tab, observed by this widget.
  final RxInt currentIndex;

  /// Called when a tab is tapped.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: Obx(
              () => IndexedStack(index: currentIndex.value, children: pages),
        ),
      ),
      bottomNavigationBar: Obx(
            () => AppBottomNavBar(
          items: items,
          currentIndex: currentIndex.value,
          onTap: onTap,
        ),
      ),
    );
  }
}