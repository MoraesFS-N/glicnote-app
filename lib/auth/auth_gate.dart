import '../widgets/app_toast.dart';
import '../screens/privacy_policy_screen.dart';
import '../widgets/loading_skeleton.dart';
import 'package:flutter/material.dart';
import '../design_system.dart';
import '../l10n/localization.dart';
import '../widgets/brand_mark.dart';
import '../widgets/login_hero.dart';
import 'login_controller.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.controller, required this.authenticatedBuilder});
  final LoginController controller;
  final Widget Function(LoginProfile) authenticatedBuilder;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? userId;
  Future<LoginProfile>? profile;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onSession);
    updateSession();
  }

  void updateSession() {
    final nextId = widget.controller.hasSession ? widget.controller.userId : null;
    if (nextId != userId) {
      userId = nextId;
      profile = nextId == null ? null : widget.controller.loadProfile();
    }
  }

  void onSession() {
    if (mounted) setState(updateSession);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onSession);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.hasSession) return LoginScreen(controller: widget.controller);
    return FutureBuilder<LoginProfile>(future: profile, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
        return widget.authenticatedBuilder(snapshot.data!);
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(body: SafeArea(child: HomeSkeleton()));
      }
      return Scaffold(body: SafeArea(child: Center(child: Padding(
        padding: GlicLayout.pagePadding,
        child: snapshot.hasError
            ? GlicCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(context.l10n.accountLoadError, textAlign: TextAlign.center),
                const SizedBox(height: GlicSpace.md),
                FilledButton(onPressed: () { setState(() { profile = widget.controller.loadProfile(); }); },
                  child: Text(context.l10n.retry)),
                TextButton(onPressed: () async {
                  try { await widget.controller.signOut(); }
                  catch (_) {
                    if (context.mounted) {
                      AppToast.show(context, context.l10n.loginError, kind: ToastKind.error);
                    }
                  }
                }, child: Text(context.l10n.signOut)),
              ]))
            : const CircularProgressIndicator(),
      ))));
    });
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final LoginController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool starting = false;

  Future<void> login() async {
    if (starting) return;
    setState(() { starting = true; });
    try { await widget.controller.signInWithGoogle(); }
    catch (_) { if (mounted) AppToast.show(context, context.l10n.loginError, kind: ToastKind.error); }
    finally { if (mounted) setState(() => starting = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(
    child: SingleChildScrollView(padding: GlicLayout.pagePadding, child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 900),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(opacity: value,
          child: Transform.translate(offset: Offset(0, 24 * (1 - value)), child: child)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const BrandWordmark(width: 150, assetPath: 'assets/branding/text_logo_home.svg'),
          const SizedBox(height: GlicSpace.xl),
          const LoginHero(),
          const SizedBox(height: GlicSpace.xl),
          GlicCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(context.l10n.loginTitle, style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
            const SizedBox(height: GlicSpace.compact),
            Text(context.l10n.loginSubtitle, textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: GlicColors.muted, height: 1.5)),
            const SizedBox(height: GlicSpace.lg),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 58)),
              onPressed: starting ? null : login,
              icon: starting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const CircleAvatar(radius: 13, backgroundColor: Colors.white,
                    child: Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 18, fontWeight: FontWeight.w700))),
              label: Text(context.l10n.signInWithGoogle),
            )),
            const SizedBox(height: GlicSpace.sm),
            TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const PrivacyPolicyScreen())), child: Text(context.l10n.privacyPolicy)),
            if (widget.controller.hasAuthError) ...[
              const SizedBox(height: GlicSpace.md),
              Text(context.l10n.loginError, textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ])),
        ]),
      ),
    )),
  )));
}
