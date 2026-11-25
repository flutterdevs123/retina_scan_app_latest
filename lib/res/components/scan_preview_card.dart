import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/scan_image.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Rounded retina image frame.
/// Set [isScanning] to show an animated scanning line over the image.
class ScanPreviewCard extends StatefulWidget {
  const ScanPreviewCard({
    super.key,
    this.imagePath,
    this.isScanning = false,
    this.height = 160,
  });

  /// Local image path (null shows a placeholder).
  final String? imagePath;

  /// Shows the scanning animation.
  final bool isScanning;

  /// Design height (scaled automatically per device).
  final double height;

  @override
  State<ScanPreviewCard> createState() => _ScanPreviewCardState();
}

class _ScanPreviewCardState extends State<ScanPreviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.isScanning) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ScanPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isScanning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius radius = BorderRadius.circular(18.sz);

    return Container(
      height: widget.height.sz,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: scheme.outline),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ScanImage(path: widget.imagePath),
            if (widget.isScanning) ...<Widget>[
              ColoredBox(color: scheme.primary.withValues(alpha: 0.1)),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    alignment: Alignment(0, -1 + 2 * _controller.value),
                    child: child,
                  );
                },
                child: Container(
                  height: 3.sz,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.8),
                        blurRadius: 14.sz,
                        spreadRadius: 2.sz,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}