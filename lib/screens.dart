import 'widgets/insulin_badge.dart';
import 'widgets/app_toast.dart';
import 'widgets/navigation_card.dart';
import 'screens/complete_profile_screen.dart';
import 'widgets/google_identity_fields.dart';
import 'widgets/complete_profile_card.dart';
import 'widgets/user_avatar.dart';
import 'screens/privacy_policy_screen.dart';
import 'widgets/loading_skeleton.dart';
import 'auth/login_controller.dart';
import 'data/app_repository.dart';
import 'data/glucose_entry.dart';
export 'data/glucose_entry.dart';
import 'l10n/localization.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'widgets/brand_mark.dart';
import 'widgets/recent_measurements_card.dart';
import 'widgets/date_range_filter.dart';
import 'widgets/emergency_contact_sheet.dart';
import 'widgets/metric_card.dart';
import 'widgets/scrollable_filter_bar.dart';
import 'widgets/glucose_summary_card.dart';
import 'design_system.dart';
import 'main.dart';


class GlicSplash extends StatefulWidget {
  const GlicSplash({super.key, this.destinationBuilder});
  final Widget Function()? destinationBuilder;
  @override
  State<GlicSplash> createState() => _GlicSplashState();
}

class _GlicSplashState extends State<GlicSplash> with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  bool started = false;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(milliseconds: 2800))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.of(context).pushReplacement(PageRouteBuilder<void>(
            pageBuilder: (context, primaryAnimation, secondaryAnimation) => widget.destinationBuilder?.call() ?? GlicShell(),
            transitionDuration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero : Duration(milliseconds: 400),
            transitionsBuilder: (context, opacity, secondaryAnimation, child) => FadeTransition(opacity: opacity, child: child),
          ));
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!started) {
      started = true;
      animation.forward();
    }
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final logo = CurvedAnimation(parent: animation, curve: Interval(0, .3, curve: Curves.easeOutCubic));
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [GlicColors.accent, GlicColors.primary, GlicColors.primaryDark],
        )),
        child: SafeArea(child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(children: [
            Spacer(),
            FadeTransition(
              opacity: reducedMotion ? AlwaysStoppedAnimation(1) : logo,
              child: ScaleTransition(
                scale: reducedMotion ? AlwaysStoppedAnimation(1) : Tween<double>(begin: .9, end: 1).animate(logo),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  BrandIcon(),
                  SizedBox(height: 20),
                  BrandWordmark(),
                ]),
              ),
            ),
            SizedBox(height: 24),
            Text(context.l10n.tagline,
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
            Spacer(),
            Text(context.l10n.splashFooter,
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12)),
            SizedBox(height: 20),
          ]),
        )),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.records, required this.onSeeAll, required this.onAdd, this.onProfile, this.loading = false, this.photoUrl, this.needsRegistration = false, this.onCompleteRegistration});
  final bool needsRegistration;
  final VoidCallback? onCompleteRegistration;
  final String? photoUrl;
  final bool loading;
  final List<GlucoseEntry> records;
  final VoidCallback onSeeAll;
  final VoidCallback onAdd;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    if (loading && records.isEmpty) return const HomeSkeleton();
    final latest = records.isEmpty ? null : records.first;
    final average = records.isEmpty ? null : (records.map((e) => e.value).reduce((a,b) => a+b) / records.length).round();
    return ListView(
      padding: GlicLayout.pagePadding,
      children: [
        Row(children: [
          Expanded(child: Align(alignment: Alignment.centerLeft,
            child: BrandWordmark(width: 125, assetPath: 'assets/branding/text_logo_home.svg'))),
          IconButton(onPressed: onProfile, tooltip: context.l10n.myProfile, icon: UserAvatar(photoUrl: photoUrl)),
        ]),
        SizedBox(height: GlicSpace.lg),
        if (needsRegistration && onCompleteRegistration != null) ...[
          CompleteProfileCard(onTap: onCompleteRegistration!),
          const SizedBox(height: GlicLayout.cardGap),
        ],
        if (latest != null) ...[
        Row(children: [
          Icon(Icons.schedule_rounded, size: 16, color: GlicColors.muted),
          SizedBox(width: GlicLayout.labelGap),
          Expanded(child: Text(context.l10n.lastReading(context.readingDate(latest.at), context.time(latest.at)),
            style: Theme.of(context).textTheme.bodySmall)),
        ]),
        SizedBox(height: GlicLayout.labelGap),
        GlucoseSummaryCard(
          value: latest.value,
          insulinUnits: latest.insulinUnits,
          detail: context.momentLabel(latest.moment),
        ),
        ] else GlicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.l10n.noReadingsTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: GlicSpace.sm),
          Text(context.l10n.noReadingsDescription),
        ])),
        SizedBox(height: GlicLayout.cardGap),
        RecentMeasurementsCard(entries: records, onSeeAll: onSeeAll),
        SizedBox(height: GlicLayout.cardGap),
        Row(children: [
          Expanded(child: MetricCard(label: context.l10n.average, value: average == null ? '—' : context.number(average), suffix: 'mg/dL', icon: Icons.monitor_heart_outlined)),
          SizedBox(width: GlicLayout.columnGap),
          Expanded(child: MetricCard(label: context.l10n.measurements, value: context.number(records.length), suffix: context.l10n.records, icon: Icons.analytics_outlined)),
        ]),
        SizedBox(height: GlicLayout.cardGap),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onAdd, icon: Icon(Icons.add), label: Text(context.l10n.newReading))),
      ],
    );
  }
}
class EntryTile extends StatelessWidget {
  const EntryTile({super.key, required this.entry});
  final GlucoseEntry entry;
  @override Widget build(BuildContext context) => GlicCard(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(children: [
      Container(padding: EdgeInsets.all(11), decoration: BoxDecoration(color: GlicColors.lavender.withValues(alpha: .6), borderRadius: BorderRadius.circular(14)),
        child: Icon(Icons.water_drop_outlined, color: GlicColors.primary)),
      SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: GlicSpace.sm, runSpacing: GlicSpace.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text(context.momentLabel(entry.moment), style: TextStyle(fontWeight: FontWeight.w700)),
          if (entry.insulinUnits != null) InsulinBadge(units: entry.insulinUnits!),
        ]),
        SizedBox(height: 3),
        Text('${context.readingDate(entry.at)} • ${context.time(entry.at)}', style: TextStyle(fontSize: 12, color: GlicColors.muted)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(context.number(entry.value), style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: GlicColors.primary)),
        Text('mg/dL', style: TextStyle(fontSize: 11, color: GlicColors.muted)),
      ]),
    ]),
  );
}

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({super.key, required this.entries});
  final List<GlucoseEntry> entries;
  @override Widget build(BuildContext context) {
    if (entries.isEmpty) return Center(child: Text(context.l10n.emptyChart));
    return LayoutBuilder(builder: (context, constraints) {
      final maximum = math.max(180, entries.map((e) => e.value).reduce(math.max) + 20);
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (final entry in entries)
          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(context.number(entry.value), style: TextStyle(fontSize: 10, color: GlicColors.muted)),
              SizedBox(height: 5),
              Container(
                height: math.max(8.0, (constraints.maxHeight - 50) * entry.value / maximum),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                  gradient: GlicGradients.measurement,
                ),
              ),
              SizedBox(height: 6),
              Text(context.readingDate(entry.at), style: TextStyle(fontSize: 9, color: GlicColors.muted)),
            ]),
          )),
      ]);
    });
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.records, this.loading = false});
  final bool loading;
  final List<GlucoseEntry> records;
  @override State<HistoryScreen> createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {
  String filter = 'Todos';
  DateTimeRange? period;
  @override Widget build(BuildContext context) {
    if (widget.loading && widget.records.isEmpty) return const HistorySkeleton();
    final items = widget.records.where((entry) {
      final matchesMoment = filter == 'Todos' || entry.moment == filter;
      final day = DateUtils.dateOnly(entry.at);
      final matchesDate = period == null ||
          (!day.isBefore(DateUtils.dateOnly(period!.start)) && !day.isAfter(DateUtils.dateOnly(period!.end)));
      return matchesMoment && matchesDate;
    }).toList();
    return ListView(padding: EdgeInsets.fromLTRB(20, 20, 20, 28), children: [
      Text(context.l10n.history, style: Theme.of(context).textTheme.headlineSmall),
      SizedBox(height: 5),
      Text(context.l10n.historySubtitle),
      SizedBox(height: 24),
      DateRangeFilter(value: period, onChanged: (value) => setState(() => period = value)),
      SizedBox(height: 12),
      ScrollableFilterBar(
        options: const ['Todos', 'Jejum', 'Após café', 'Após almoço', 'Após lanche'],
        selected: filter,
        labelBuilder: context.momentLabel,
        onSelected: (option) => setState(() => filter = option),
      ),
      SizedBox(height: 20),
      SectionHeading(context.l10n.overview),
      SizedBox(height: 12),
      GlicCard(child: SizedBox(height: 185, child: GlucoseChart(entries: items.take(7).toList().reversed.toList()))),
      SizedBox(height: 22),
      SectionHeading(context.l10n.measurements, trailing: Text(context.l10n.readingCount(items.length), style: TextStyle(fontSize: 12))),
      SizedBox(height: 12),
      if (items.isEmpty) GlicCard(child: Text(context.l10n.emptyHistory)),
      ...items.map((item) => Padding(padding: EdgeInsets.only(bottom: 9), child: EntryTile(entry: item))),
    ]);
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.initialName, this.initialEmail, this.onSignOut, this.repository, this.profile, this.onProfileUpdated});
  final ValueChanged<LoginProfile>? onProfileUpdated;
  final AppRepository? repository;
  final LoginProfile? profile;
  final String? initialName;
  final String? initialEmail;
  final Future<void> Function()? onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late LoginProfile profile;
  bool contactLoading = false;
  bool contactFailed = false;
  bool signingOut = false;

  @override
  void initState() {
    super.initState();
    profile = widget.profile ?? LoginProfile(id: 'demo', name: widget.initialName ?? '', email: widget.initialEmail);
    if (widget.repository != null) loadContact();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != null && widget.profile != oldWidget.profile) profile = widget.profile!;
  }

  Future<void> completeRegistration() async {
    final saved = await Navigator.of(context).push<LoginProfile>(MaterialPageRoute(
      builder: (_) => CompleteProfileScreen(profile: profile, repository: widget.repository)));
    if (!mounted || saved == null) return;
    setState(() => profile = saved);
    widget.onProfileUpdated?.call(saved);
    AppToast.show(context, context.l10n.profileSaved);
  }
  EmergencyContact? emergencyContact;

  Future<void> loadContact() async {
    setState(() { contactLoading = true; contactFailed = false; });
    try {
      final loaded = await widget.repository!.contact();
      if (mounted) setState(() => emergencyContact = loaded);
    } catch (_) {
      if (mounted) setState(() => contactFailed = true);
    } finally { if (mounted) setState(() => contactLoading = false); }
  }

  Future<void> editEmergencyContact() async {
    if (contactFailed) {
      await loadContact();
      if (!mounted || contactFailed) return;
    }
    final contact = await showModalBottomSheet<EmergencyContact>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: GlicColors.background,
      isDismissible: widget.repository == null,
      enableDrag: widget.repository == null,
      builder: (_) => EmergencyContactSheet(contact: emergencyContact, onSave: widget.repository?.saveContact),
    );
    if (!mounted || contact == null) return;
    setState(() => emergencyContact = contact.name.isEmpty ? null : contact);
    AppToast.show(context, context.l10n.contactSaved);
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(20),
    children: [
      Text(context.l10n.myProfile, style: Theme.of(context).textTheme.headlineSmall),
      SizedBox(height: 8),
      Text(context.l10n.profileSubtitle),
      SizedBox(height: 24),
      GlicCard(
        child: Column(children: [
          UserAvatar(photoUrl: profile.photoUrl, radius: 36),
          SizedBox(height: 12),
          Text(profile.name.isEmpty ? context.l10n.yourProfile : profile.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(profile.username == null ? context.l10n.profileTagline : '@${profile.username}'),
          if (profile.diabetesType != null) ...[
            const SizedBox(height: GlicSpace.sm),
            Text('${context.l10n.diabetesType}: ${context.diabetesTypeLabel(profile.diabetesType!)}'),
          ],
          if (profile.ageAt(DateTime.now()) != null) ...[
            const SizedBox(height: GlicSpace.sm),
            Text(context.l10n.ageYears(profile.ageAt(DateTime.now())!)),
          ],
        ]),
      ),
      SizedBox(height: 24),
      SectionHeading(context.l10n.personalDetails),
      const SizedBox(height: GlicSpace.compact),
      GlicCard(child: GoogleIdentityFields(profile: profile)),
      const SizedBox(height: GlicSpace.lg),
      if (contactLoading)
        const GlicCard(padding: EdgeInsets.zero, child: ContactSkeleton())
      else NavigationCard(
        icon: Icons.contact_emergency_outlined,
        title: context.l10n.emergencyContact,
        subtitle: contactFailed ? context.l10n.syncError : emergencyContact == null ? context.l10n.addContact :
          '${emergencyContact!.name} • ${emergencyContact!.phone}${emergencyContact!.relationship.isEmpty ? '' : '\n${emergencyContact!.relationship}'}',
        onTap: editEmergencyContact,
      ),
      const SizedBox(height: GlicLayout.cardGap),
      NavigationCard(
        icon: Icons.privacy_tip_outlined,
        title: context.l10n.privacyPolicy,
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const PrivacyPolicyScreen())),
      ),
      const SizedBox(height: GlicLayout.cardGap),
      CompleteProfileCard(onTap: completeRegistration, complete: !profile.needsRegistration),
      const SizedBox(height: GlicSpace.md),
      if (widget.onSignOut != null) ...[
        OutlinedButton.icon(
          onPressed: signingOut ? null : () async {
            setState(() => signingOut = true);
            try { await widget.onSignOut!(); }
            catch (_) {
              if (context.mounted) AppToast.show(context, context.l10n.loginError, kind: ToastKind.error);
            } finally { if (mounted) setState(() => signingOut = false); }
          },
          icon: const Icon(Icons.logout_rounded),
          label: Text(context.l10n.signOut),
        ),
        const SizedBox(height: GlicSpace.md),
      ],
      if (widget.repository == null) Text(context.l10n.sessionNotice,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
    ],
  );
}
