import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Simple search box with a clear button (not part of a form).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;

  /// Called on every key press and when the clear button is tapped.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.sz,
          vertical: 14.sz,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 22.sz,
          color: scheme.onSurfaceVariant,
        ),
        // The clear button only exists while there is text.
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (BuildContext context, TextEditingValue value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                controller.clear();
                onChanged('');
              },
              icon: Icon(
                Icons.close_rounded,
                size: 20.sz,
                color: scheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}