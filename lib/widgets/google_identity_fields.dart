import 'package:flutter/material.dart';
import '../auth/login_controller.dart';
import '../design_system.dart';
import '../l10n/localization.dart';
import 'locked_text_field.dart';

class GoogleIdentityFields extends StatelessWidget {
  const GoogleIdentityFields({super.key, required this.profile});
  final LoginProfile profile;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    LockedTextField(value: profile.name, label: context.l10n.name, icon: Icons.person_outline),
    const SizedBox(height: GlicSpace.md),
    LockedTextField(value: profile.email ?? '', label: context.l10n.email, icon: Icons.mail_outline),
    const SizedBox(height: GlicSpace.compact),
    Text(context.l10n.googleIdentityHint, style: Theme.of(context).textTheme.bodySmall),
  ]);
}
