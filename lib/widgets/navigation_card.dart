import 'package:flutter/material.dart';
import '../design_system.dart';

/// Atalho compartilhado para abrir telas e formulários do aplicativo.
class NavigationCard extends StatelessWidget {
  const NavigationCard({super.key, required this.icon, required this.title,
    this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GlicCard(
    padding: EdgeInsets.zero,
    child: ListTile(
      shape: Theme.of(context).cardTheme.shape,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: GlicSpace.inset, vertical: GlicSpace.compact),
      minTileHeight: 88,
      horizontalTitleGap: GlicSpace.md,
      leading: CircleAvatar(radius: 24, backgroundColor: GlicColors.lavender,
        child: Icon(icon, size: 24, color: GlicColors.primary)),
      title: Text(title, style: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w700, color: GlicColors.primary)),
      subtitle: subtitle == null ? null : Padding(
        padding: const EdgeInsets.only(top: GlicSpace.xs),
        child: Text(subtitle!, style: const TextStyle(color: GlicColors.muted, height: 1.4))),
      trailing: const Icon(Icons.chevron_right_rounded, color: GlicColors.primary),
      onTap: onTap,
    ),
  );
}
