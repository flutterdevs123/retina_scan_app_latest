import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Bottom line of auth screens, e.g. "Don't have an account? Sign Up".
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  /// Plain text before the link.
  final String message;

  /// Tappable text.
  final String actionLabel;

  /// Called when the link is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Wrap moves the link to the next line on very narrow screens.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6.sz),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}