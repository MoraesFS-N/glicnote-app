import 'insulin_badge.dart';
import '../l10n/localization.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system.dart';
import '../screens.dart' show GlucoseEntry;

class RecentMeasurementsCard extends StatelessWidget {
  const RecentMeasurementsCard({super.key, required this.entries, required this.onSeeAll});
  final List<GlucoseEntry> entries;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final recent = entries.take(4).toList();
    final hasInsulin = recent.any((entry) => entry.insulinUnits != null);
    final maximum = recent.fold<int>(1, (value, entry) => math.max(value, entry.value));
    return Card(
      color: GlicColors.surfaceSoft,
      child: Padding(
        padding: GlicLayout.cardPadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(context.l10n.recentReadings, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: GlicSpace.lg),
          if (recent.isEmpty) Text(context.l10n.noReadings)
          else LayoutBuilder(builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final slots = math.max(1, (4 / scale).floor());
            final width = math.max(0.0,
              (constraints.maxWidth - GlicLayout.columnGap * (slots - 1)) / slots);
            return Wrap(spacing: GlicLayout.columnGap, runSpacing: GlicLayout.columnGap, children: [
              for (final entry in recent)
                SizedBox(width: width, child: MeasurementColumn(entry: entry, barFraction: entry.value / maximum, reserveInsulin: hasInsulin)),
            ]);
          }),
          SizedBox(height: GlicSpace.lg),
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: GlicColors.primary),
            onPressed: onSeeAll,
            icon: Icon(Icons.history_rounded),
            label: Text(context.l10n.seeAll, textAlign: TextAlign.center),
          ),
        ]),
      ),
    );
  }
}

class MeasurementColumn extends StatelessWidget {
  const MeasurementColumn({super.key, required this.entry, required this.barFraction, this.reserveInsulin = false});
  final GlucoseEntry entry;
  final double barFraction;
  final bool reserveInsulin;

  String period(BuildContext context) => entry.at.hour < 12 ? context.l10n.morning : entry.at.hour < 18 ? context.l10n.afternoon : context.l10n.night;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '${context.readingDate(entry.at)} ${context.time(entry.at)}, ${context.momentLabel(entry.moment)}, ${context.number(entry.value)} mg/dL${entry.insulinLabel(context) == null ? '' : ', ${entry.insulinLabel(context)}'}',
    child: ExcludeSemantics(child: Container(
      padding: EdgeInsets.symmetric(horizontal: GlicSpace.sm, vertical: GlicSpace.compact),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .55), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        SizedBox(height: MediaQuery.textScalerOf(context).scale(12) * 1.5,
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(context.readingDate(entry.at), softWrap: false, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))),
        SizedBox(height: GlicSpace.xxs),
        SizedBox(height: MediaQuery.textScalerOf(context).scale(11) * 1.5,
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(period(context), softWrap: false, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GlicColors.muted)))),
        SizedBox(height: GlicSpace.md),
        SizedBox(height: 130, child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 24,
            height: math.max(8, 130 * barFraction.clamp(0, 1)),
            decoration: BoxDecoration(gradient: GlicGradients.measurement, borderRadius: BorderRadius.circular(5)),
          ),
        )),
        SizedBox(height: GlicSpace.sm),
        SizedBox(height: MediaQuery.textScalerOf(context).scale(20) * 1.5,
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(context.number(entry.value), softWrap: false, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlicColors.ink)))),
        Text('mg/dL', style: TextStyle(fontSize: 10, color: GlicColors.muted)),
        if (reserveInsulin) ...[
          const SizedBox(height: GlicSpace.sm),
          SizedBox(
            height: MediaQuery.textScalerOf(context).scale(12) * 1.5 + GlicSpace.sm,
            child: entry.insulinUnits == null ? null : Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: InsulinBadge(units: entry.insulinUnits!))),
          ),
        ],
      ]),
    )),
  );
}
