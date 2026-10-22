import 'package:flutter/material.dart';
import '../l10n/localization.dart';
import 'navigation_card.dart';

class CompleteProfileCard extends StatelessWidget {
  const CompleteProfileCard({super.key, required this.onTap, this.complete = false});
  final VoidCallback onTap;
  final bool complete;

  @override
  Widget build(BuildContext context) => NavigationCard(
    icon: complete ? Icons.manage_accounts_outlined : Icons.person_add_alt_1_outlined,
    title: complete ? context.l10n.additionalDetails : context.l10n.completeRegistration,
    subtitle: context.l10n.registrationHint,
    onTap: onTap,
  );
}
