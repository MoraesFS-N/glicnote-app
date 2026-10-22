import 'package:flutter/material.dart';
import '../design_system.dart';
import '../l10n/localization.dart';

/// Um pulso compartilhado por área evita um controlador para cada placeholder.
class SkeletonPulse extends StatefulWidget {
  const SkeletonPulse({super.key, required this.child});
  final Widget child;
  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse> with SingleTickerProviderStateMixin {
  late final AnimationController pulse = AnimationController(vsync: this,
    duration: const Duration(milliseconds: 1200));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) || !TickerMode.valuesOf(context).enabled) {
      pulse.stop();
      pulse.value = 1;
    } else {
      pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() { pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Semantics(label: context.l10n.loading,
    liveRegion: true, child: ExcludeSemantics(child: IgnorePointer(
      child: FadeTransition(opacity: Tween<double>(begin: .55, end: 1)
        .animate(CurvedAnimation(parent: pulse, curve: Curves.easeInOut)), child: widget.child),
    )));
}

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, this.width, this.height = 16, this.radius = 8});
  final double? width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(width: width, height: height,
    decoration: BoxDecoration(color: GlicColors.lavender,
      borderRadius: BorderRadius.circular(radius)));
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});
  @override
  Widget build(BuildContext context) => SkeletonPulse(child: ListView(
    padding: GlicLayout.pagePadding, children: [
      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SkeletonBlock(width: 125, height: 32), SkeletonBlock(width: 40, height: 40, radius: 20),
      ]),
      const SizedBox(height: GlicSpace.lg),
      const Align(alignment: Alignment.centerLeft, child: SkeletonBlock(width: 180, height: 12)),
      const SizedBox(height: GlicSpace.sm),
      const GlicCard(child: Column(children: [
        SkeletonBlock(width: 130, height: 130, radius: 65),
        SizedBox(height: GlicSpace.md), SkeletonBlock(width: 100, height: 32),
        SizedBox(height: GlicSpace.sm), SkeletonBlock(width: 140, height: 14),
      ])),
      const SizedBox(height: GlicLayout.cardGap),
      GlicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SkeletonBlock(width: 160, height: 20),
        const SizedBox(height: GlicSpace.lg),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (final height in [75.0, 110.0, 90.0, 120.0])
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: GlicSpace.xs),
              child: SkeletonBlock(height: height, radius: 12))),
        ]),
        const SizedBox(height: GlicSpace.lg), const SkeletonBlock(height: 48, radius: 24),
      ])),
      const SizedBox(height: GlicLayout.cardGap),
      const Row(children: [
        Expanded(child: GlicCard(child: SkeletonBlock(height: 70))),
        SizedBox(width: GlicLayout.columnGap),
        Expanded(child: GlicCard(child: SkeletonBlock(height: 70))),
      ]),
    ],
  ));
}

class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});
  @override
  Widget build(BuildContext context) => SkeletonPulse(child: ListView(
    padding: GlicLayout.pagePadding, children: [
      const Align(alignment: Alignment.centerLeft, child: SkeletonBlock(width: 130, height: 28)),
      const SizedBox(height: GlicSpace.lg),
      const GlicCard(child: SkeletonBlock(height: 48)),
      const SizedBox(height: GlicSpace.md),
      const SkeletonBlock(height: 36, radius: 18),
      const SizedBox(height: GlicSpace.lg),
      const GlicCard(child: SkeletonBlock(height: 185)),
      const SizedBox(height: GlicSpace.lg),
      for (var i = 0; i < 4; i++) ...[
        const GlicCard(child: Row(children: [
          SkeletonBlock(width: 42, height: 42, radius: 21),
          SizedBox(width: GlicSpace.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SkeletonBlock(width: 110), SizedBox(height: GlicSpace.sm), SkeletonBlock(width: 75, height: 12),
          ])),
          SkeletonBlock(width: 48, height: 28),
        ])),
        const SizedBox(height: GlicSpace.sm),
      ],
    ],
  ));
}

class ContactSkeleton extends StatelessWidget {
  const ContactSkeleton({super.key});
  @override
  Widget build(BuildContext context) => const SkeletonPulse(child: Padding(
    padding: EdgeInsets.all(GlicSpace.inset), child: Row(children: [
      SkeletonBlock(width: 48, height: 48, radius: 24), SizedBox(width: GlicSpace.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SkeletonBlock(width: 165), SizedBox(height: GlicSpace.sm),
        SkeletonBlock(width: 110, height: 12),
      ])),
    ]),
  ));
}
