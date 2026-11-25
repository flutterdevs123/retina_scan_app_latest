import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Small pill that shows the role (Doctor / Patient).
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sz, vertical: 4.sz),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.sz),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(role.icon, size: 14.sz, color: color),
          6.hSpace,
          Text(
            role.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}