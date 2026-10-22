import 'package:flutter/material.dart';
import '../design_system.dart';

/// Avatar compartilhado, sem falhas visuais quando a imagem não carregar.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.photoUrl, this.radius = 20});
  final String? photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(photoUrl ?? '');
    final showPhoto = uri != null && uri.scheme == 'https' && uri.host.isNotEmpty && uri.userInfo.isEmpty;
    final fallback = Center(child: Icon(Icons.person_outline,
      size: radius * 1.1, color: GlicColors.primary));
    return SizedBox.square(dimension: radius * 2, child: ClipOval(child: ColoredBox(
      color: GlicColors.lavender,
      child: showPhoto ? Image.network(photoUrl!, width: radius * 2, height: radius * 2,
        fit: BoxFit.cover, excludeFromSemantics: true,
        loadingBuilder: (context, child, progress) => progress == null ? child : fallback,
        errorBuilder: (context, error, stackTrace) => fallback,
      ) : fallback,
    )));
  }
}
