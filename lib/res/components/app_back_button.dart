import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Round back button used at the top of inner screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onPressed});

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      shape: CircleBorder(side: BorderSide(color: scheme.outline)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44.sz,
          height: 44.sz,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sz,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}