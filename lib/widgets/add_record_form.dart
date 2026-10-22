import 'app_toast.dart';
import '../data/api_client.dart';
import '../l10n/localization.dart';
import 'package:flutter/material.dart';
import '../design_system.dart';
import '../screens.dart' show GlucoseEntry;

class AddRecordForm extends StatefulWidget {
  const AddRecordForm({super.key, required this.onSave, required this.onCancel, this.onPersist, this.persistent = false, this.existingEntries = const []});
  final List<GlucoseEntry> existingEntries;
  final Future<GlucoseEntry> Function(GlucoseEntry)? onPersist;
  final bool persistent;
  final ValueChanged<GlucoseEntry> onSave;
  final VoidCallback onCancel;
  @override State<AddRecordForm> createState() => _AddRecordFormState();
}
class _AddRecordFormState extends State<AddRecordForm> {
  final form = GlobalKey<FormState>();
  final controller = TextEditingController();
  final insulinController = TextEditingController();
  String moment = 'Jejum';
  bool saving = false;
  GlucoseEntry? pending;
  @override void dispose() { controller.dispose(); insulinController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => PopScope(canPop: !saving, child: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Text(context.l10n.newReading, style: Theme.of(context).textTheme.headlineSmall),
    SizedBox(height: 8),
    Text(context.l10n.readingSubtitle),
    SizedBox(height: 24),
    GlicCard(child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(
        controller: controller,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: context.l10n.glucoseField, prefixIcon: Icon(Icons.water_drop_outlined)),
        validator: (value) {
          final number = int.tryParse(value?.trim() ?? '');
          return number == null || number <= 0 || number > 1000 ? context.l10n.valueError : null;
        },
      ),
      SizedBox(height: 18),
      DropdownButtonFormField<String>(
        initialValue: moment,
        decoration: InputDecoration(labelText: context.l10n.readingMoment),
        items: ['Jejum', 'Após café', 'Após almoço', 'Após lanche', 'Após janta', 'Outro']
          .map((e) => DropdownMenuItem(value: e, child: Text(context.momentLabel(e)))).toList(),
        onChanged: (v) => setState(() => moment = v ?? moment),
      ),
      SizedBox(height: 18),
      TextFormField(
        controller: insulinController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: context.l10n.insulinField,
          hintText: context.l10n.insulinHint,
          prefixIcon: Icon(Icons.water_drop_outlined),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return null;
          final units = double.tryParse(text.replaceAll(',', '.'));
          return units == null || !units.isFinite || units < 0 || units >= 100000 || (units * 1000 - (units * 1000).round()).abs() > .000001
              ? context.l10n.insulinError : null;
        },
      ),
      SizedBox(height: 24),
      FilledButton.icon(
        onPressed: saving ? null : () async {
          if (saving) return;
          if (form.currentState?.validate() != true) return;
          final value = int.parse(controller.text.trim());
          final units = insulinController.text.trim().isEmpty ? null
            : double.parse(insulinController.text.trim().replaceAll(',', '.'));
          if (pending == null || pending!.value != value || pending!.moment != moment || pending!.insulinUnits != units) {
            pending = GlucoseEntry(value: value, moment: moment, at: DateTime.now(), insulinUnits: units);
          }
          if (widget.existingEntries.any((entry) => pending!.conflictsWith(entry))) {
            AppToast.show(context, moment == 'Outro' ? context.l10n.duplicateOtherReading : context.l10n.duplicateReading, kind: ToastKind.warning);
            return;
          }
          setState(() { saving = true; });
          try {
            final saved = widget.onPersist == null ? pending! : await widget.onPersist!(pending!);
            if (mounted) {
              setState(() => saving = false);
              await WidgetsBinding.instance.endOfFrame;
              if (mounted) widget.onSave(saved);
            }
          } catch (error) {
            if (context.mounted) {
              final duplicate = error is ApiFailure && error.code == 'duplicate_reading';
              AppToast.show(context, duplicate
                ? (moment == 'Outro' ? context.l10n.duplicateOtherReading : context.l10n.duplicateReading)
                : context.l10n.saveError, kind: duplicate ? ToastKind.warning : ToastKind.error);
            }
          } finally {
            if (mounted) setState(() => saving = false);
          }
        },
        icon: Icon(Icons.check),
        label: Text(context.l10n.saveReading),
      ),
      SizedBox(height: 8),
      TextButton(onPressed: saving ? null : widget.onCancel, child: Text(context.l10n.cancel)),
    ]))),
    SizedBox(height: 15),
    if (!widget.persistent) Text(context.l10n.memoryNotice, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
  ])));
}

