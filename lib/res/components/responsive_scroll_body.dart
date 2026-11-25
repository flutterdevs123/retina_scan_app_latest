import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Standard body for every screen.
///
/// - Respects notches / system bars (SafeArea).
/// - Always takes the FULL width, so content is never pushed to one side.
/// - Scrolls when content is taller than the screen (no pixel overflow).
/// - Fills the screen height when content is shorter, so `Spacer` and
///   `MainAxisAlignment.center` still work.
///
/// Note: don't put a `ListView` directly inside [child]; use a `Column`.
class ResponsiveScrollBody extends StatelessWidget {
  const ResponsiveScrollBody({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.useSafeArea = true,
  });

  /// Screen content (usually a `Column`).
  final Widget child;

  /// Custom padding. Defaults to a responsive 20 / 16 padding.
  final EdgeInsetsGeometry? padding;

  /// Custom scroll physics.
  final ScrollPhysics? physics;

  /// Whether to wrap the body in a [SafeArea].
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 20.sz, vertical: 16.sz);

    final Widget body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: physics,
          child: ConstrainedBox(
            // minWidth is the fix: without it the child shrinks to its
            // widest element and sticks to the left edge.
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: resolvedPadding,
              child: IntrinsicHeight(child: child),
            ),
          ),
        );
      },
    );

    return useSafeArea ? SafeArea(child: body) : body;
  }
}