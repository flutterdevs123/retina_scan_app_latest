import 'package:flutter/material.dart';
import 'package:retina_scan_app/models/notification_model.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/theme/app_colors.dart';
import 'package:retina_scan_app/res/utils/date_formatter.dart';

/// One row of the notifications list. Unread items have a dot.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final Color color = switch (notification.type) {
      NotificationType.newRequest => scheme.primary,
      NotificationType.accepted => AppColors.success,
      NotificationType.rejected => scheme.error,
    };

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44.sz,
            height: 44.sz,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.sz),
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(notification.type.icon, size: 22.sz, color: color),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        notification.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: notification.isRead
                              ? FontWeight.w600
                              : FontWeight.w800,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 9.sz,
                        height: 9.sz,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primary,
                        ),
                      ),
                  ],
                ),
                4.vSpace,
                Text(
                  notification.body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                6.vSpace,
                Text(
                  DateFormatter.relative(notification.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}