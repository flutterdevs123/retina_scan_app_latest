import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Gradient call-to-action banner (title, text and one button).
class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
    this.icon = Icons.remove_red_eye_rounded,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  /// Large faded icon on the right.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(18.sz),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sz),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[scheme.primary, scheme.secondary],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.3),
            blurRadius: 18.sz,
            offset: Offset(0, 8.sz),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onPrimary,
                  ),
                ),
                6.vSpace,
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.4,
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
                14.vSpace,
                Material(
                  color: scheme.onPrimary,
                  borderRadius: BorderRadius.circular(12.sz),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.sz),
                    onTap: onPressed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sz,
                        vertical: 9.sz,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            buttonLabel,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          ),
                          6.hSpace,
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18.sz,
                            color: scheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.hSpace,
          Icon(icon, size: 70.sz, color: scheme.onPrimary.withValues(alpha: 0.25)),
        ],
      ),
    );
  }
}