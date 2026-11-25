import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Round bell button with a red badge showing the unread count.
class NotificationBell extends StatelessWidget {
  const NotificationBell({
    super.key,
    required this.count,
    required this.onPressed,
  });

  /// Number of unread notifications (badge is hidden when 0).
  final int count;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Material(
      color: scheme.surface,
      shape: CircleBorder(side: BorderSide(color: scheme.outline)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 46.sz,
          height: 46.sz,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                Icons.notifications_none_rounded,
                size: 24.sz,
                color: scheme.onSurface,
              ),
              if (count > 0)
                Positioned(
                  top: 6.sz,
                  right: 6.sz,
                  child: Container(
                    constraints: BoxConstraints(minWidth: 18.sz),
                    padding: EdgeInsets.symmetric(horizontal: 4.sz, vertical: 1.sz),
                    decoration: BoxDecoration(
                      color: scheme.error,
                      borderRadius: BorderRadius.circular(10.sz),
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: scheme.onError,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}