import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/components/app_avatar.dart';
import 'package:retina_scan_app/res/components/role_badge.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/name_utils.dart';

/// Top section of the Home tab: avatar, greeting, name, role badge and an
/// optional [trailing] widget (usually the notification bell).
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.name,
    required this.role,
    this.trailing,
  });

  /// Name of the logged in user.
  final String name;

  /// Role of the logged in user (shown as a badge).
  final UserRole role;

  /// Widget at the end of the row.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        AppAvatar(initials: NameUtils.initials(name), size: 54),
        14.hSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.welcomeBack,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              2.vSpace,
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              6.vSpace,
              RoleBadge(role: role),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[10.hSpace, trailing!],
      ],
    );
  }
}