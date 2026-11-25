import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';

/// Small banner for form level feedback (no snackbar needed).
/// Red for errors, green for success.
class AppInlineMessage extends StatelessWidget {
  const AppInlineMessage({
    super.key,
    required this.message,
    this.isError = true,
  });

  /// Text shown inside the banner.
  final String message;

  /// True for an error banner, false for a success banner.
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isError ? theme.colorScheme.error : AppColors.success;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.sz, vertical: 12.sz),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.sz),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            size: 20.sz,
            color: color,
          ),
          10.hSpace,
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}