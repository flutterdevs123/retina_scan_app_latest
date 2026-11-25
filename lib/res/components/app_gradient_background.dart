import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Full-screen soft gradient background that follows the active theme.
/// Reuse it on any screen that needs a modern background.
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            isLight
                ? AppColors.lightGradientStart
                : AppColors.darkGradientStart,
            isLight ? AppColors.lightGradientEnd : AppColors.darkGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}