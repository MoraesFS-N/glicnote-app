import 'package:flutter/material.dart';
import '../design_system.dart';
import '../l10n/localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sections = [
      (l.privacyResponsibleTitle, l.privacyResponsibleBody),
      (l.privacyDataTitle, l.privacyDataBody),
      (l.privacyPurposeTitle, l.privacyPurposeBody),
      (l.privacySessionTitle, l.privacySessionBody),
      (l.privacySharingTitle, l.privacySharingBody),
      (l.privacyProvidersTitle, l.privacyProvidersBody),
      (l.privacyRetentionTitle, l.privacyRetentionBody),
      (l.privacyRightsTitle, l.privacyRightsBody),
      (l.privacyUpdatesTitle, l.privacyUpdatesBody),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.privacyPolicy)),
      body: SelectionArea(child: ListView(padding: GlicLayout.pagePadding, children: [
        Text(l.privacyVersion, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: GlicSpace.md),
        GlicCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, color: GlicColors.primary),
          const SizedBox(width: GlicSpace.compact),
          Expanded(child: Text(l.privacyDraft)),
        ])),
        for (final section in sections) ...[
          const SizedBox(height: GlicLayout.cardGap),
          GlicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Semantics(header: true, child: Text(section.$1,
              style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: GlicSpace.compact),
            Text(section.$2, style: const TextStyle(height: 1.6)),
          ])),
        ],
      ])),
    );
  }
}
