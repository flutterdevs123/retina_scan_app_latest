import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Scrollable body for dashboard tabs.
///
/// Lighter than `ResponsiveScrollBody` (no IntrinsicHeight), so long lists
/// stay fast. The bottom is not padded for the system bar, because the
/// bottom navigation bar already handles it.
class TabScrollBody extends StatelessWidget {
  const TabScrollBody({super.key, required this.children, this.padding});

  /// Tab content.
  final List<Widget> children;

  /// Custom padding. Defaults to a responsive 20 / 16 padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: padding ?? EdgeInsets.fromLTRB(20.sz, 16.sz, 20.sz, 24.sz),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}