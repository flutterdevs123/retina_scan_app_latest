import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Wrapping row of small tappable chips (for quick text suggestions).
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<String> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Wrap(
      spacing: 8.sz,
      runSpacing: 8.sz,
      children: <Widget>[
        for (final String item in items)
          GestureDetector(
            onTap: () => onTap(item),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sz, vertical: 7.sz),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(20.sz),
                border: Border.all(color: scheme.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.add_rounded, size: 15.sz, color: scheme.primary),
                  4.hSpace,
                  Text(
                    item,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}