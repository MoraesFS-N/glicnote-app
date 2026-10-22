import 'app_toast.dart';
import '../l10n/localization.dart';
import 'package:flutter/material.dart';
import 'emergency_contact_fields.dart';

class EmergencyContact {
  const EmergencyContact({required this.name, required this.phone, this.relationship = ''});
  final String name;
  final String phone;
  final String relationship;
}

class EmergencyContactSheet extends StatefulWidget {
  const EmergencyContactSheet({super.key, this.contact, this.onSave});
  final Future<void> Function(EmergencyContact)? onSave;
  final EmergencyContact? contact;

  @override
  State<EmergencyContactSheet> createState() => _EmergencyContactSheetState();
}

class _EmergencyContactSheetState extends State<EmergencyContactSheet> {
  bool saving = false;
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.contact?.name);
  late final phone = TextEditingController(text: widget.contact?.phone);
  late final relationship = TextEditingController(text: widget.contact?.relationship);

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    relationship.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(canPop: !saving, child: SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
    child: Form(key: form, child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmergencyContactFields(name: name, phone: phone, relationship: relationship, requireInternational: widget.onSave != null),
        SizedBox(height: 24),
        FilledButton.icon(
          icon: Icon(Icons.check),
          label: Text(context.l10n.saveContact),
          onPressed: saving ? null : () async {
            if (form.currentState?.validate() != true) return;
            final contact = EmergencyContact(name: name.text.trim(), phone: phone.text.trim(),
              relationship: relationship.text.trim());
            setState(() { saving = true; });
            try {
              await widget.onSave?.call(contact);
              if (mounted) {
                setState(() => saving = false);
                await WidgetsBinding.instance.endOfFrame;
                if (context.mounted) Navigator.of(context).pop(contact);
              }
            } catch (_) {
              if (context.mounted) AppToast.show(context, context.l10n.saveError, kind: ToastKind.error);
            } finally { if (mounted) setState(() => saving = false); }
          },
        ),
        SizedBox(height: 8),
        TextButton(onPressed: saving ? null : () => Navigator.of(context).pop(), child: Text(context.l10n.cancel)),
      ],
    )),
  ));
}
