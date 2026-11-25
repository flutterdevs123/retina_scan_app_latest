import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Reusable rounded card used for tips, stats and actions.
/// Pass [onTap] to make it tappable (with ripple effect).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  /// Card content.
  final Widget child;

  /// Tap callback. Null makes the card non-interactive.
  final VoidCallback? onTap;

  /// Inner padding. Defaults to a responsive 16.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sz),
        side: BorderSide(color: scheme.outline),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.all(16.sz),
          child: child,
        ),
      ),
    );
  }
}