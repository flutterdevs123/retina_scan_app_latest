import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/components/stat_card.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Data of one stat card.
class StatItem {
  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.tone = StatTone.primary,
  });

  final IconData icon;
  final String value;
  final String label;
  final StatTone tone;
}

/// Lays out compact [StatCard]s in two columns.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.items});

  final List<StatItem> items;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];

    for (int i = 0; i < items.length; i += 2) {
      final bool hasSecond = i + 1 < items.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < items.length ? 10.sz : 0),
          child: Row(
            children: <Widget>[
              Expanded(child: _card(items[i])),
              10.hSpace,
              Expanded(
                child: hasSecond ? _card(items[i + 1]) : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _card(StatItem item) => StatCard(
    icon: item.icon,
    value: item.value,
    label: item.label,
    tone: item.tone,
  );
}