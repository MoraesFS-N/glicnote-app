import 'package:flutter/material.dart';
import '../design_system.dart';
import '../l10n/localization.dart';

/// Compact insulin amount shared by reading cards and history.
class InsulinBadge extends StatelessWidget {
  const InsulinBadge({super.key, required this.units});
  final double units;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: GlicSpace.sm, vertical: GlicSpace.xs),
    decoration: BoxDecoration(color: GlicColors.lavender.withValues(alpha: .65),
      borderRadius: BorderRadius.circular(10)),
    child: Text(context.l10n.insulinAmount(context.number(units)),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: GlicColors.primaryDark)),
  );
}
