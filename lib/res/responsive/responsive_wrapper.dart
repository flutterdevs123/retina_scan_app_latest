import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_utils.dart';

/// Wraps the whole app (used inside `GetMaterialApp.builder`).
///
/// It does 3 things:
/// 1. Updates the global scale factor when screen size/orientation changes.
/// 2. Scales text automatically (while limiting extreme system font sizes).
/// 3. Centers the content with a max width on wide screens.
class ResponsiveWrapper extends StatefulWidget {
  const ResponsiveWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper> {
  /// Last screen size we calculated the scale for.
  Size? _lastSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MediaQueryData data = MediaQuery.of(context);

    // Keyboard open/close also triggers this method, but the screen size
    // stays the same. Skipping here avoids rebuilding the whole app on
    // every keyboard frame (big speed improvement).
    if (data.size == _lastSize) return;
    _lastSize = data.size;

    ResponsiveUtils.update(data);
    // Force every widget below to rebuild so they pick up new sizes.
    _rebuildDescendants();
  }

  /// Marks all descendant elements dirty so `.sz` values are recalculated.
  void _rebuildDescendants() {
    void visitor(Element element) {
      element.markNeedsBuild();
      element.visitChildren(visitor);
    }

    (context as Element).visitChildren(visitor);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);

    // Respect the user's system font size, but keep it in a safe range.
    final double systemTextScale =
    data.textScaler.scale(1.0).clamp(0.9, 1.15).toDouble();

    return MediaQuery(
      data: data.copyWith(
        textScaler: TextScaler.linear(systemTextScale * ResponsiveUtils.scale),
      ),
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveUtils.maxContentWidth,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}