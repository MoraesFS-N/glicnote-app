import 'widgets/app_toast.dart';
import 'screens/complete_profile_screen.dart';
import 'data/app_repository.dart';
import 'package:uuid/uuid.dart';
import 'auth/auth_gate.dart';
import 'auth/login_controller.dart';
import 'auth/supabase_login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/localization.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'design_system.dart';
import 'screens.dart';
import 'widgets/sliding_tab_view.dart';
import 'widgets/add_record_form.dart';

const glicAuthOptions = FlutterAuthClientOptions(
  authFlowType: AuthFlowType.pkce, persistSession: true, autoRefreshToken: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoginController? login;
  if (const bool.fromEnvironment('AUTH_ENABLED')) {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY',
      defaultValue: String.fromEnvironment('SUPABASE_ANON_KEY'));
    const apiUrl = String.fromEnvironment('API_BASE_URL');
    if (url.isEmpty || key.isEmpty || apiUrl.isEmpty) {
      throw StateError('Missing authentication configuration. Use the local auth configuration file.');
    }
    await Supabase.initialize(url: url, publishableKey: key, debug: false,
      authOptions: glicAuthOptions);
    login = SupabaseLoginController(client: Supabase.instance.client, apiBaseUrl: Uri.parse(apiUrl),
      redirectUrl: const String.fromEnvironment('AUTH_REDIRECT_URL', defaultValue: 'com.glicnote.app://login-callback'));
  }
  runApp(GlicNoteApp(loginController: login));
}

class GlicNoteApp extends StatelessWidget {
  const GlicNoteApp({super.key, this.loginController});
  final LoginController? loginController;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GlicNote',
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    localeListResolutionCallback: (locales, supported) {
      for (final locale in locales ?? <Locale>[]) {
        if (supported.any((value) => value.languageCode == locale.languageCode)) return locale;
      }
      return const Locale('en');
    },
    debugShowCheckedModeBanner: false,
    theme: GlicTheme.light,
    home: GlicSplash(destinationBuilder: loginController == null ? null : () => AuthGate(
      controller: loginController!,
      authenticatedBuilder: (profile) => GlicShell(key: ValueKey(profile.id),
        profile: profile, repository: loginController!.repository, onSignOut: loginController!.signOut),
    )),
  );
}

class GlicShell extends StatefulWidget {
  const GlicShell({super.key, this.profile, this.onSignOut, this.repository});
  final AppRepository? repository;
  final LoginProfile? profile;
  final Future<void> Function()? onSignOut;
  @override
  State<GlicShell> createState() => _GlicShellState();
}

class _GlicShellState extends State<GlicShell> {
  LoginProfile? currentProfile;
  int selected = 0;
  int recordsRevision = 0;
  bool loading = false;
  bool loadFailed = false;
  final records = <GlucoseEntry>[
    GlucoseEntry(value: 94, moment: 'Jejum', at: DateTime(2026, 10, 20, 7, 30)),
    GlucoseEntry(value: 109, moment: 'Após café', at: DateTime(2026, 10, 19, 9, 10)),
    GlucoseEntry(value: 159, moment: 'Após almoço', at: DateTime(2026, 10, 19, 13, 20)),
    GlucoseEntry(value: 115, moment: 'Após lanche', at: DateTime(2026, 10, 18, 16, 30)),
    GlucoseEntry(value: 90, moment: 'Após café', at: DateTime(2026, 10, 18, 9, 0)),
    GlucoseEntry(value: 119, moment: 'Após almoço', at: DateTime(2026, 10, 17, 13, 20)),
  ];

  @override
  void initState() {
    super.initState();
    currentProfile = widget.profile;
    // Demonstration records never appear in an authenticated user's session.
    if (widget.profile != null) records.clear();
    if (widget.repository != null) reload();
  }

  Future<void> completeRegistration() async {
    if (currentProfile == null) return;
    final saved = await Navigator.of(context).push<LoginProfile>(MaterialPageRoute(
      builder: (_) => CompleteProfileScreen(profile: currentProfile!, repository: widget.repository)));
    if (!mounted || saved == null) return;
    setState(() => currentProfile = saved);
    AppToast.show(context, context.l10n.profileSaved);
  }

  Future<void> reload() async {
    setState(() { loading = true; loadFailed = false; });
    final revision = recordsRevision;
    try {
      final loaded = await widget.repository!.readings();
      if (!mounted) return;
      if (revision != recordsRevision) { await reload(); return; }
      setState(() { records.clear(); records.addAll(loaded); });
    } catch (_) {
      if (mounted) setState(() => loadFailed = true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void addEntry(GlucoseEntry entry) {
    setState(() {
      recordsRevision++;
      records.removeWhere((old) => entry.id != null && old.id == entry.id);
      records.insert(0, entry);
      records.sort((a,b) => b.at.compareTo(a.at));
      selected = 0;
    });
  }

  Future<void> openRegistration() async {
    String requestId = const Uuid().v4();
    GlucoseEntry? pendingEntry;
    final entry = await showModalBottomSheet<GlucoseEntry>(
      context: context,
      isScrollControlled: true,
      isDismissible: widget.repository == null,
      enableDrag: widget.repository == null,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: GlicColors.background,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AddRecordForm(
          existingEntries: records,
          persistent: widget.repository != null,
          onPersist: widget.repository == null ? null :
            (entry) {
              if (pendingEntry != null && !identical(pendingEntry, entry)) requestId = const Uuid().v4();
              pendingEntry = entry;
              return widget.repository!.addReading(entry, requestId);
            },
          onSave: (entry) => Navigator.of(context).pop(entry),
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
    if (!mounted || entry == null) return;
    addEntry(entry);
    AppToast.show(context, context.l10n.readingSaved);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(children: [
        if (loading && records.isNotEmpty) const LinearProgressIndicator(),
        if (loadFailed) Padding(padding: const EdgeInsets.all(GlicSpace.md),
          child: Column(children: [Text(context.l10n.syncError, textAlign: TextAlign.center),
            TextButton(onPressed: reload, child: Text(context.l10n.retry))])),
        Expanded(child: SlidingTabView(
        index: selected,
        children: [
          HomeScreen(records: records, photoUrl: currentProfile?.photoUrl,
            needsRegistration: currentProfile?.needsRegistration ?? false, onCompleteRegistration: completeRegistration, loading: loading, onSeeAll: () => setState(() => selected = 1), onAdd: openRegistration, onProfile: () => setState(() => selected = 2)),
          HistoryScreen(records: records, loading: loading),
          ProfileScreen(repository: widget.repository, profile: currentProfile,
            onProfileUpdated: (profile) => setState(() => currentProfile = profile),
            initialName: currentProfile?.name, initialEmail: currentProfile?.email, onSignOut: widget.onSignOut),
        ],
      )),
      ]),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: selected == 0 ? 0 : selected + 1,
      onDestinationSelected: (value) {
        if (value == 1) {
          openRegistration();
        } else {
          setState(() => selected = value == 0 ? 0 : value - 1);
        }
      },
      destinations: [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: context.l10n.home),
        NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: context.l10n.register),
        NavigationDestination(icon: Icon(Icons.show_chart_outlined), selectedIcon: Icon(Icons.show_chart), label: context.l10n.history),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: context.l10n.profile),
      ],
    ),
  );
}
