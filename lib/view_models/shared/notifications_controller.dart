import 'package:get/get.dart';
import 'package:retina_scan_app/models/notification_model.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// Logic of the notifications screen.
class NotificationsController extends BaseUserController {
  /// Notifications of the logged in user, newest first.
  List<NotificationModel> get items => data.notificationsOf(myId);

  /// True when at least one notification is unread.
  bool get hasUnread => unreadCount > 0;

  /// Marks everything as read.
  void markAllRead() => data.markAllRead(myId);

  /// Marks the notification as read and opens its report.
  void open(NotificationModel notification) {
    data.markRead(notification.id);
    if (notification.reportId != null) {
      Get.toNamed(AppRoutes.reportDetail, arguments: notification.reportId);
    }
  }
}