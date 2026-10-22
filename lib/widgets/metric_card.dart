import 'package:flutter/material.dart';
import '../design_system.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.label, required this.value, required this.suffix, required this.icon});
  final String label, value, suffix;
  final IconData icon;
  @override Widget build(BuildContext context) => GlicCard(padding: GlicLayout.compactCardPadding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: GlicColors.primary),
    const SizedBox(height: GlicSpace.compact),
    Text(label, style: const TextStyle(fontSize: 12, color: GlicColors.muted)),
    const SizedBox(height: GlicSpace.sm),
    Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: GlicColors.ink)),
    Text(suffix, style: const TextStyle(fontSize: 11, color: GlicColors.muted)),
  ]));
}

