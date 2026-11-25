import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/app_avatar.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/name_utils.dart';

/// Row card for a person: avatar, name, ID and an optional subtitle.
/// Used for doctor and patient search results.
class PersonTile extends StatelessWidget {
  const PersonTile({
    super.key,
    required this.name,
    required this.id,
    this.subtitle,
    this.onTap,
  });

  final String name;
  final String id;

  /// Extra line, e.g. specialty or number of reports.
  final String? subtitle;

  /// Tap callback. A chevron is shown only when this is set.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.sz),
      child: Row(
        children: <Widget>[
          AppAvatar(initials: NameUtils.initials(name), size: 46),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                2.vSpace,
                Text(
                  id,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  2.vSpace,
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              size: 24.sz,
              color: scheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}