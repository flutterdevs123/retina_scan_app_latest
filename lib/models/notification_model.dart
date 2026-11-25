import 'package:flutter/material.dart';

/// Kinds of notifications the app can show.
enum NotificationType {
  newRequest,
  accepted,
  rejected;

  /// Icon that represents the notification.
  IconData get icon => switch (this) {
    NotificationType.newRequest => Icons.mark_email_unread_rounded,
    NotificationType.accepted => Icons.check_circle_rounded,
    NotificationType.rejected => Icons.cancel_rounded,
  };
}

/// One notification of a user.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.reportId,
    this.isRead = false,
  });

  final String id;

  /// ID of the user who receives it.
  final String userId;

  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;

  /// Report that opens when the notification is tapped.
  final String? reportId;

  final bool isRead;

  /// Returns a copy with the given fields replaced.
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      reportId: reportId,
      isRead: isRead ?? this.isRead,
    );
  }
}