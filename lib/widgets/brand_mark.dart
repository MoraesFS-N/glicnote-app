import '../l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandIcon extends StatelessWidget {
  const BrandIcon({super.key, this.size = 112});
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/branding/icon.svg', width: size, height: size,
    semanticsLabel: context.l10n.iconLabel,
  );
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.width = 230, this.color, this.assetPath = 'assets/branding/text_logo.svg'});
  final double width;
  final Color? color;
  final String assetPath;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    assetPath, width: width,
    colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    semanticsLabel: 'GlicNote',
  );
}
