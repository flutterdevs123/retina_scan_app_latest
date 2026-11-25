import 'package:retina_scan_app/res/constants/app_strings.dart';

/// Date and time helpers used by report and notification cards.
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "Just now", "5m ago", "3h ago", "2d ago" or a full date after a week.
  static String relative(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return AppStrings.justNow;
    if (diff.inMinutes < 60) return AppStrings.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return AppStrings.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return AppStrings.daysAgo(diff.inDays);
    return full(date);
  }

  /// Example: 05 Mar 2026
  static String full(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    return '$day ${_months[date.month - 1]} ${date.year}';
  }

  /// Example: 05 Mar 2026, 3:45 PM
  static String withTime(DateTime date) {
    final int hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    return '${full(date)}, $hour12:$minute $period';
  }
}