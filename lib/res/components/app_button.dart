import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Visual style of [AppButton].
enum AppButtonVariant {
  /// Filled with the primary color (main action).
  primary,

  /// Outlined with the primary color (secondary action).
  secondary,

  /// Outlined with the error color (logout, reject, delete).
  danger,
}

/// Reusable button used across the whole app.
///
/// Usage: `AppButton(label: 'Continue', onPressed: controller.submit)`
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.variant = AppButtonVariant.primary,
  });

  /// Button text.
  final String label;

  /// Tap callback. Pass null to disable the button.
  final VoidCallback? onPressed;

  /// Optional icon shown after the label.
  final IconData? icon;

  /// Shows a loader instead of the label and blocks taps.
  final bool isLoading;

  /// Fixed design width. Null means full width.
  final double? width;

  /// Visual style of the button.
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final bool filled = variant == AppButtonVariant.primary;
    final Color accent =
    variant == AppButtonVariant.danger ? scheme.error : scheme.primary;
    // Text and icon color: readable on a filled button, accent otherwise.
    final Color contentColor = filled ? scheme.onPrimary : accent;

    final Widget content = isLoading
        ? SizedBox(
      width: 22.sz,
      height: 22.sz,
      child: CircularProgressIndicator(
        strokeWidth: 2.5.sz,
        color: contentColor,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
        ),
        if (icon != null) ...<Widget>[
          8.hSpace,
          Icon(icon, size: 20.sz),
        ],
      ],
    );

    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.sz),
    );

    return SizedBox(
      width: width?.sz ?? double.infinity,
      height: 54.sz,
      child: filled
          ? ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: contentColor,
          disabledBackgroundColor: accent.withValues(alpha: 0.5),
          disabledForegroundColor: contentColor,
          elevation: 0,
          shape: shape,
        ),
        child: content,
      )
          : OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: 0.6)),
          shape: shape,
        ),
        child: content,
      ),
    );
  }
}