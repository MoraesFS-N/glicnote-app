import '../widgets/app_toast.dart';
import '../widgets/locked_text_field.dart';
import 'package:flutter/material.dart';
import '../auth/login_controller.dart';
import '../data/app_repository.dart';
import '../design_system.dart';
import '../l10n/localization.dart';
import '../widgets/google_identity_fields.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, required this.profile, this.repository});
  final LoginProfile profile;
  final AppRepository? repository;
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final form = GlobalKey<FormState>();
  late final username = TextEditingController(text: widget.profile.username);
  late final date = TextEditingController();
  late DateTime? birthDate = widget.profile.birthDate;
  late String? diabetesType = widget.profile.diabetesType;
  late String zone = widget.profile.timeZone;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadZone();
  }

  Future<void> loadZone() async {
    try {
      final deviceZone = await widget.repository?.deviceTimeZone();
      if (mounted && !saving && deviceZone != null) setState(() => zone = deviceZone);
    } catch (_) { /* Keep the account's saved time zone when unavailable. */ }
  }

  @override
  void dispose() { username.dispose(); date.dispose(); super.dispose(); }

  Future<void> selectBirthDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final result = await showDatePicker(context: context,
      initialDate: birthDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900), lastDate: now,
      initialEntryMode: DatePickerEntryMode.input,
      helpText: context.l10n.birthDate,
    );
    if (mounted && result != null) setState(() => birthDate = DateUtils.dateOnly(result));
  }

  Future<void> save() async {
    if (saving || form.currentState?.validate() != true) return;
    final chosenUsername = username.text.trim();
    final selectedZone = zone;
    final selectedBirth = birthDate;
    final selectedType = diabetesType;
    FocusScope.of(context).unfocus();
    setState(() { saving = true; });
    try {
      final saved = widget.repository == null
        ? widget.profile.withRegistration(username: chosenUsername, timeZone: selectedZone, birthDate: selectedBirth, diabetesType: selectedType)
        : await widget.repository!.saveProfile(widget.profile, chosenUsername,
            timeZone: selectedZone, birthDate: selectedBirth, diabetesType: selectedType);
      if (!mounted) return;
      setState(() => saving = false);
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.of(context).pop(saved);
    } catch (_) {
      if (mounted) AppToast.show(context, context.l10n.profileSaveError, kind: ToastKind.error);
    } finally { if (mounted) setState(() => saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    date.text = birthDate == null ? '' : context.fullDate(birthDate!);
    return PopScope(canPop: !saving, child: Scaffold(
      appBar: AppBar(title: Text(context.l10n.completeRegistration)),
      body: ListView(padding: GlicLayout.pagePadding, children: [
        Text(context.l10n.registrationDescription),
        const SizedBox(height: GlicSpace.lg),
        GlicCard(child: GoogleIdentityFields(profile: widget.profile)),
        const SizedBox(height: GlicLayout.cardGap),
        GlicCard(child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(context.l10n.additionalDetails, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: GlicSpace.md),
          TextFormField(controller: username, enabled: !saving, autocorrect: false,
            decoration: InputDecoration(labelText: context.l10n.username,
              prefixIcon: const Icon(Icons.alternate_email), helperText: context.l10n.usernameError),
            validator: (value) => RegExp(r'^[a-z0-9_]{3,30}$').hasMatch(value?.trim() ?? '')
              ? null : context.l10n.usernameError),
          const SizedBox(height: GlicSpace.md),
          DropdownButtonFormField<String>(
            initialValue: diabetesType,
            decoration: InputDecoration(labelText: context.l10n.diabetesTypeField,
              prefixIcon: const Icon(Icons.health_and_safety_outlined)),
            items: [
              DropdownMenuItem<String>(value: null, child: Text(context.l10n.notProvided)),
              DropdownMenuItem(value: 'type_1', child: Text(context.l10n.diabetesTypeOne)),
              DropdownMenuItem(value: 'type_2', child: Text(context.l10n.diabetesTypeTwo)),
            ],
            onChanged: saving ? null : (value) => setState(() => diabetesType = value),
          ),
          const SizedBox(height: GlicSpace.md),
          TextFormField(controller: date, readOnly: true, enabled: !saving,
            onTap: selectBirthDate,
            decoration: InputDecoration(labelText: context.l10n.birthDate,
              helperText: context.l10n.birthDateHint,
              prefixIcon: const Icon(Icons.cake_outlined),
              suffixIcon: birthDate == null ? const Icon(Icons.calendar_month_outlined)
                : IconButton(tooltip: context.l10n.clearBirthDate,
                    onPressed: saving ? null : () => setState(() => birthDate = null),
                    icon: const Icon(Icons.close_rounded)))),
          const SizedBox(height: GlicSpace.md),
          LockedTextField(value: zone, label: context.l10n.timeZone,
            helperText: context.l10n.timeZoneHint, icon: Icons.public),
          const SizedBox(height: GlicSpace.lg),
          FilledButton.icon(onPressed: saving ? null : save,
            icon: saving ? const SizedBox.square(dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
            label: Text(context.l10n.saveProfile)),
          TextButton(onPressed: saving ? null : () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel)),
        ]))),
      ]),
    ));
  }
}
