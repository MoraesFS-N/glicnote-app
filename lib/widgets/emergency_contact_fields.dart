import '../l10n/localization.dart';
import 'package:flutter/material.dart';
import '../design_system.dart';

class EmergencyContactFields extends StatelessWidget {
  const EmergencyContactFields({super.key, required this.name, required this.phone, required this.relationship, this.requireInternational = false});
  final bool requireInternational;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController relationship;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeading(context.l10n.emergencyContact),
      SizedBox(height: 8),
      Text(context.l10n.contactSubtitle),
      SizedBox(height: 18),
      TextFormField(
        controller: name,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: context.l10n.contactName, prefixIcon: Icon(Icons.person_outline)),
        validator: (value) => phone.text.trim().isNotEmpty && (value?.trim().isEmpty ?? true)
            ? context.l10n.contactNameError : null,
      ),
      SizedBox(height: 18),
      TextFormField(
        controller: phone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(labelText: context.l10n.phone, hintText: context.l10n.phoneHint, prefixIcon: Icon(Icons.phone_outlined)),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty && name.text.trim().isEmpty) return null;
          final digits = text.replaceAll(RegExp(r'\D'), '');
          if (requireInternational && !RegExp(r'^\+[1-9][0-9]{6,14}$').hasMatch(text.replaceAll(RegExp(r'[\s()\-]'), ''))) return context.l10n.internationalPhoneError;
          return digits.length < 10 || digits.length > 15 || !RegExp(r'^\+?[\d\s()\-]+$').hasMatch(text)
              ? context.l10n.phoneError : null;
        },
      ),
      SizedBox(height: 18),
      TextFormField(
        controller: relationship,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: context.l10n.relationship, hintText: context.l10n.relationshipHint, prefixIcon: Icon(Icons.favorite_outline)),
      ),
    ],
  );
}
