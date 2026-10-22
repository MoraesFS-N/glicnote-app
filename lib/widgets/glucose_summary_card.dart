import 'insulin_badge.dart';
import '../l10n/localization.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Resumo de uma medição. Não calcula faixas ou recomendações clínicas.
class GlucoseSummaryCard extends StatelessWidget {
  const GlucoseSummaryCard({
    super.key,
    required this.value,
    this.title,
    this.unit = 'mg/dL',
    this.detail,
    this.insulinUnits,
  });

  final int value;
  final String? title;
  final String unit;
  final String? detail;
  final double? insulinUnits;

  @override
  Widget build(BuildContext context) => GlicCard(
    padding: GlicLayout.cardPadding,
    child: LayoutBuilder(builder: (context, constraints) {
      final content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: GlicSpace.sm, runSpacing: GlicSpace.sm, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text(title ?? context.l10n.glucoseLevel, style: Theme.of(context).textTheme.titleMedium),
          if (insulinUnits != null) InsulinBadge(units: insulinUnits!),
        ]),
        const SizedBox(height: GlicSpace.lg),
        SummaryValue(value: context.number(value), unit: unit, icon: Icons.water_drop),
        if (detail != null) ...[
          const SizedBox(height: GlicSpace.compact),
          Text(detail!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ]);
      final compact = constraints.maxWidth < 260 || MediaQuery.textScalerOf(context).scale(16) > 24;
      if (compact) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          content,
          const SizedBox(height: GlicSpace.inset),
          const Center(child: GlucoseWave(size: 112)),
        ]);
      }
      return Row(children: [
        Expanded(child: content),
        const SizedBox(width: GlicSpace.md),
        const GlucoseWave(),
      ]);
    }),
  );
}

class SummaryValue extends StatelessWidget {
  const SummaryValue({super.key, required this.value, required this.unit, required this.icon});
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Icon(icon, color: GlicColors.primary, size: 24),
    const SizedBox(width: GlicSpace.sm),
    Flexible(child: Text.rich(TextSpan(children: [
      TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      TextSpan(text: ' $unit', style: const TextStyle(fontSize: 12)),
    ]))),
  ]);
}

/// Motivo decorativo da referência, sem representar uma meta clínica.
class GlucoseWave extends StatefulWidget {
  const GlucoseWave({super.key, this.size = 136});
  final double size;

  @override
  State<GlucoseWave> createState() => _GlucoseWaveState();
}

class _GlucoseWaveState extends State<GlucoseWave> with SingleTickerProviderStateMixin {
  late final AnimationController motion = AnimationController(
    vsync: this, duration: const Duration(seconds: 8));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      motion.stop();
      motion.value = 0;
    } else if (!motion.isAnimating) {
      motion.repeat();
    }
  }

  @override
  void dispose() {
    motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: SizedBox.square(
    dimension: widget.size,
    child: ClipOval(child: ColoredBox(
      color: Colors.white,
      child: CustomPaint(painter: _WavePainter(motion)),
    )),
  ));
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.motion) : super(repaint: motion);
  final Animation<double> motion;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sway = math.sin(motion.value * math.pi * 2);
    final drift = w * .07 * sway;
    final tilt = h * .035 * sway;
    final back = Path()..moveTo(0, h * .5 + tilt)
      ..cubicTo(w * .4 - drift, h * .22, w * .7 - drift, h * .94, w, h * .5 - tilt)
      ..lineTo(w, h)..lineTo(0, h)..close();
    canvas.drawPath(back, Paint()..color = GlicColors.accent.withValues(alpha: .1));
    final front = Path()..moveTo(0, h * .5 + tilt)
      ..cubicTo(w * .3 + drift, h * .94, w * .6 + drift, h * .22, w, h * .5 - tilt)
      ..lineTo(w, h)..lineTo(0, h)..close();
    canvas.drawPath(front, Paint()..shader = GlicGradients.measurement.createShader(Offset.zero & size));
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => oldDelegate.motion != motion;
}
