import 'package:glicnote_app/widgets/loading_skeleton.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/auth/auth_gate.dart';
import 'package:glicnote_app/auth/login_controller.dart';
import 'package:glicnote_app/main.dart';
import 'test_app.dart';

class FakeLoginController extends LoginController {
  String? id;
  int launches = 0;
  bool failLaunch = false;
  Completer<LoginProfile> account = Completer<LoginProfile>();
  @override bool get hasSession => id != null;
  @override String? get userId => id;
  @override bool get hasAuthError => false;
  void session(String? value) { id = value; notifyListeners(); }
  @override Future<void> signInWithGoogle() async {
    launches++;
    if (failLaunch) throw const LoginFailure();
  }
  @override Future<LoginProfile> loadProfile() => account.future;
  @override Future<void> signOut() async => session(null);
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.clearAccessibilityFeaturesTestValue();
  });
  testWidgets('Login fits a small screen with enlarged text', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final login = FakeLoginController();
    await tester.pumpWidget(localizedTestApp(home: MediaQuery(
      data: const MediaQueryData(size: Size(320, 568),
        textScaler: TextScaler.linear(1.5), disableAnimations: true),
      child: LoginScreen(controller: login))));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Entrar com Google'));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Entrar com Google'));
    await tester.pumpAndSettle();
    expect(login.launches, 1);
    await tester.pumpWidget(const SizedBox());
    login.dispose();
  });

  testWidgets('Login stays closed until a session exists and handles launch failure', (tester) async {
    final login = FakeLoginController();
    await tester.pumpWidget(localizedTestApp(home: AuthGate(controller: login,
      authenticatedBuilder: (_) => const Text('Private area'))));
    expect(find.text('Private area'), findsNothing);
    await tester.tap(find.text('Entrar com Google'));
    await tester.pumpAndSettle();
    expect(login.launches, 1);
    expect(find.text('Private area'), findsNothing);
    login.failLaunch = true;
    await tester.tap(find.text('Entrar com Google'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível entrar. Tente novamente.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    login.dispose();
  });

  testWidgets('Authenticated area waits for API confirmation and clears on logout', (tester) async {
    final login = FakeLoginController();
    await tester.pumpWidget(localizedTestApp(home: AuthGate(controller: login,
      authenticatedBuilder: (profile) => GlicShell(key: ValueKey(profile.id), profile: profile, onSignOut: login.signOut))));
    login.session('alice');
    await tester.pump();
    expect(find.byType(HomeSkeleton), findsOneWidget);
    expect(find.byType(GlicShell), findsNothing);
    login.account.complete(const LoginProfile(id: 'alice', name: 'Alice', email: 'alice@example.com'));
    await tester.pumpAndSettle();
    expect(find.text('Sua primeira aferição'), findsOneWidget);
    expect(find.text('94'), findsNothing);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Alice'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Sair da conta'), 200,
      scrollable: find.byType(Scrollable).hitTestable().first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair da conta'));
    await tester.pumpAndSettle();
    expect(find.byType(GlicShell), findsNothing);
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    login.dispose();
  });

  testWidgets('API failure never opens the authenticated area and supports retry', (tester) async {
    final login = FakeLoginController()..id = 'alice';
    await tester.pumpWidget(localizedTestApp(home: AuthGate(controller: login,
      authenticatedBuilder: (_) => const Text('Private area'))));
    login.account.completeError(const LoginFailure());
    await tester.pumpAndSettle();
    expect(find.text('Private area'), findsNothing);
    expect(find.text('Tentar novamente'), findsOneWidget);
    login.account = Completer<LoginProfile>();
    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();
    login.account.complete(const LoginProfile(id: 'alice', name: 'Alice'));
    await tester.pumpAndSettle();
    expect(find.text('Private area'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    login.dispose();
  });
}
