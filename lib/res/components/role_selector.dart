import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Two selectable tiles (Doctor / Patient) used on the sign up screen.
class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  /// Currently selected role.
  final UserRole selected;

  /// Called when the user taps a different role.
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.roleLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        8.vSpace,
        Row(
          children: <Widget>[
            Expanded(
              child: _RoleTile(
                role: UserRole.patient,
                isSelected: selected == UserRole.patient,
                onTap: () => onChanged(UserRole.patient),
              ),
            ),
            12.hSpace,
            Expanded(
              child: _RoleTile(
                role: UserRole.doctor,
                isSelected: selected == UserRole.doctor,
                onTap: () => onChanged(UserRole.doctor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// One tile of the selector.
class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 14.sz, horizontal: 8.sz),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primary.withValues(alpha: 0.12)
              : scheme.surface,
          borderRadius: BorderRadius.circular(12.sz),
          border: Border.all(
            color: isSelected ? scheme.primary : scheme.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              role.icon,
              size: 26.sz,
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            ),
            6.vSpace,
            Text(
              role.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}