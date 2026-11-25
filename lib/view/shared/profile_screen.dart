import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/components/app_avatar.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/info_row.dart';
import 'package:retina_scan_app/res/components/role_badge.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/tab_header.dart';
import 'package:retina_scan_app/res/components/tab_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/theme_controller.dart';
import 'package:retina_scan_app/view_models/shared/profile_controller.dart';

/// Profile tab (same for doctor and patient): details, theme and logout.
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScrollBody(
      children: <Widget>[
        const TabHeader(title: AppStrings.profileTitle),
        24.vSpace,
        Obx(() {
          final UserModel? user = controller.user;
          if (user == null) return const SizedBox.shrink();
          return _ProfileContent(user: user);
        }),
        24.vSpace,
        const SectionTitle(title: 'Appearance'),
        10.vSpace,
        const _ThemeSelector(),
        28.vSpace,
        AppButton(
          label: AppStrings.logOut,
          icon: Icons.logout_rounded,
          variant: AppButtonVariant.danger,
          onPressed: controller.logout,
        ),
      ],
    );
  }
}

/// User avatar, name, ID, role badge and contact details.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        AppAvatar(initials: user.initials, size: 92),
        14.vSpace,
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        4.vSpace,
        Text(
          user.id,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        10.vSpace,
        RoleBadge(role: user.role),
        24.vSpace,
        SizedBox(
          width: double.infinity,
          child: AppCard(
            child: Column(
              children: <Widget>[
                InfoRow(
                  icon: Icons.mail_outline_rounded,
                  label: AppStrings.labelEmail,
                  value: user.email.isEmpty ? AppStrings.notSet : user.email,
                ),
                if (user.role == UserRole.doctor) ...<Widget>[
                  16.vSpace,
                  InfoRow(
                    icon: Icons.medical_services_outlined,
                    label: AppStrings.specialtyLabel,
                    value: user.specialty.isEmpty
                        ? AppStrings.notSet
                        : user.specialty,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Three-way theme selector: Light / Dark / System.
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final ThemeController theme = Get.find<ThemeController>();

    return Obx(() {
      final ThemeMode current = theme.mode.value;

      return AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            _ThemeOption(
              icon: Icons.light_mode_rounded,
              label: 'Light',
              selected: current == ThemeMode.light,
              onTap: () => theme.setMode(ThemeMode.light),
            ),
            const Divider(height: 1),
            _ThemeOption(
              icon: Icons.dark_mode_rounded,
              label: 'Dark',
              selected: current == ThemeMode.dark,
              onTap: () => theme.setMode(ThemeMode.dark),
            ),
            const Divider(height: 1),
            _ThemeOption(
              icon: Icons.settings_suggest_rounded,
              label: 'System',
              selected: current == ThemeMode.system,
              onTap: () => theme.setMode(ThemeMode.system),
            ),
          ],
        ),
      );
    });
  }
}

/// One row of the theme selector.
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color color = selected ? scheme.primary : scheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sz, vertical: 14.sz),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22.sz, color: color),
            12.hSpace,
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 22.sz, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}