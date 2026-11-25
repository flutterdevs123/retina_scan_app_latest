import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/app_logo.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Top section of every auth screen: logo badge, title and subtitle.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.remove_red_eye_rounded,
  });

  /// Main heading.
  final String title;

  /// Short description under the heading.
  final String subtitle;

  /// Icon inside the logo badge.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppLogo(size: 72, icon: icon),
        20.vSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        8.vSpace,
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}