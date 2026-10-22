import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system.dart';
import 'brand_mark.dart';
import 'glucose_summary_card.dart';

/// Ilustração de entrada compartilhável, com movimento suave e acessível.
class LoginHero extends StatefulWidget {
  const LoginHero({super.key});

  @override
  State<LoginHero> createState() => _LoginHeroState();
}

class _LoginHeroState extends State<LoginHero> with SingleTickerProviderStateMixin {
  late final AnimationController motion = AnimationController(
    vsync: this, duration: const Duration(seconds: 7));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      motion.stop();
      motion.value = 0;
    } else {
      motion.repeat();
    }
  }

  @override
  void dispose() {
    motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: SizedBox(
    width: 290, height: 252,
    child: AnimatedBuilder(animation: motion, builder: (context, _) {
      final sway = math.sin(motion.value * math.pi * 2);
      return Stack(alignment: Alignment.center, children: [
        Container(width: 236, height: 236, decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [GlicColors.surfaceSoft,
            GlicColors.lavender.withValues(alpha: .65)]))),
        Positioned(left: 8, top: 38, child: Transform.translate(
          offset: Offset(sway * 3, -sway * 5),
          child: Transform.rotate(angle: -.12 + sway * .035,
            child: Container(padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: GlicColors.surfaceSoft,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: GlicColors.primaryDark.withValues(alpha: .09),
                  blurRadius: 24, offset: const Offset(0, 12))]),
              child: const BrandIcon(size: 126))))),
        Positioned(right: 0, bottom: 14, child: Transform.translate(
          offset: Offset(-sway * 4, sway * 5),
          child: const GlucoseWave(size: 142))),
        Positioned(right: 28, top: 27, child: Icon(Icons.auto_awesome_rounded,
          size: 28, color: GlicColors.primary.withValues(alpha: .65))),
        Positioned(left: 34, bottom: 17, child: Container(width: 10, height: 10,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: GlicColors.coral))),
      ]);
    }),
  ));
}
