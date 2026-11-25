import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/notification_model.dart';
import 'package:retina_scan_app/res/components/app_inner_scaffold.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/notification_tile.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/shared/notifications_controller.dart';

/// List of notifications (same for doctor and patient).
class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppInnerScaffold(
      title: AppStrings.notificationsTitle,
      // "Mark all read" only appears while something is unread.
      trailing: Obx(
            () => controller.hasUnread
            ? TextButton(
          onPressed: controller.markAllRead,
          child: Text(
            AppStrings.markAllRead,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        )
            : const SizedBox.shrink(),
      ),
      children: <Widget>[
        Obx(() {
          final List<NotificationModel> items = controller.items;
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: AppStrings.emptyNotifTitle,
              message: AppStrings.emptyNotifMsg,
            );
          }
          return Column(
            children: <Widget>[
              for (final NotificationModel item in items)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.sz),
                  child: NotificationTile(
                    notification: item,
                    onTap: () => controller.open(item),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}