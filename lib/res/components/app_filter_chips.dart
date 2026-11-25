import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Horizontal row of selectable chips (works with any option type).
class AppFilterChips<T> extends StatelessWidget {
  const AppFilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final List<T> options;
  final T selected;

  /// Returns the text shown on each chip.
  final String Function(T option) labelOf;

  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final T option in options)
            Padding(
              padding: EdgeInsets.only(right: 8.sz),
              child: GestureDetector(
                onTap: () => onSelected(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sz,
                    vertical: 8.sz,
                  ),
                  decoration: BoxDecoration(
                    color: option == selected ? scheme.primary : scheme.surface,
                    borderRadius: BorderRadius.circular(20.sz),
                    border: Border.all(
                      color:
                      option == selected ? scheme.primary : scheme.outline,
                    ),
                  ),
                  child: Text(
                    labelOf(option),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: option == selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}