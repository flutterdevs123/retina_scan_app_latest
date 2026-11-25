import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Row of dots where the active dot stretches into a pill.
class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  /// Total number of pages.
  final int count;

  /// Index of the page currently visible.
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(count, (int index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 4.sz),
          width: isActive ? 28.sz : 8.sz,
          height: 8.sz,
          decoration: BoxDecoration(
            color: isActive ? color : color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8.sz),
          ),
        );
      }),
    );
  }
}