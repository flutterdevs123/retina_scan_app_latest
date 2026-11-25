import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/scan_image.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Retina image with an Original / AI Heatmap switch (when a heatmap exists).
class ScanImageViewer extends StatefulWidget {
  const ScanImageViewer({
    super.key,
    required this.originalPath,
    this.heatmapPath,
    this.height = 200,
  });

  final String? originalPath;
  final String? heatmapPath;
  final double height;

  @override
  State<ScanImageViewer> createState() => _ScanImageViewerState();
}

class _ScanImageViewerState extends State<ScanImageViewer> {
  bool _showHeatmap = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius radius = BorderRadius.circular(18.sz);
    final bool hasHeatmap = (widget.heatmapPath ?? '').isNotEmpty;

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
            ScanImage(
              path: _showHeatmap ? widget.heatmapPath : widget.originalPath,
            ),
            if (hasHeatmap)
              Positioned(
                left: 10.sz,
                bottom: 10.sz,
                child: Row(
                  children: <Widget>[
                    _Chip(
                      label: ApiStrings.originalTab,
                      selected: !_showHeatmap,
                      onTap: () => setState(() => _showHeatmap = false),
                    ),
                    8.hSpace,
                    _Chip(
                      label: ApiStrings.heatmapTab,
                      selected: _showHeatmap,
                      onTap: () => setState(() => _showHeatmap = true),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sz, vertical: 6.sz),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary
              : scheme.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16.sz),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}