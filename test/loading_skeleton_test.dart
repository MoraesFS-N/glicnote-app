import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:glicnote_app/auth/login_controller.dart';
import 'package:glicnote_app/data/api_client.dart';
import 'package:glicnote_app/data/app_repository.dart';
import 'package:glicnote_app/main.dart';
import 'package:glicnote_app/widgets/loading_skeleton.dart';
import 'package:glicnote_app/l10n/localization.dart';
import 'test_app.dart';

void main() {
  testWidgets('Pending data shows skeletons, and empty states appear only after completion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final readings = Completer<http.Response>();
    final contact = Completer<http.Response>();
    final api = ApiClient(baseUrl: Uri.parse('http://localhost'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {},
      client: MockClient((request) => request.url.path.endsWith('emergency-contact')
        ? contact.future : readings.future));
    await tester.pumpWidget(localizedTestApp(home: GlicShell(repository: AppRepository(api),
      profile: const LoginProfile(id: 'alice', name: 'Alice'))));
    await tester.pumpAndSettle();
    expect(find.byType(HomeSkeleton), findsOneWidget);
    expect(find.text('Sua primeira aferição'), findsNothing);
    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();
    expect(find.byType(HistorySkeleton), findsOneWidget);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(ContactSkeleton), 200,
      scrollable: find.byType(Scrollable).hitTestable().first);
    expect(find.byType(ContactSkeleton), findsOneWidget);
    readings.complete(http.Response('{"items":[],"nextCursor":null}', 200));
    contact.complete(http.Response('{}', 404));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeSkeleton), findsNothing);
    expect(find.text('Sua primeira aferição'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    api.close();
  });

  testWidgets('Only the current measurement day is replaced by Hoje', (tester) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final previous = today.subtract(const Duration(days: 2));
    await tester.pumpWidget(localizedTestApp(home: Builder(builder: (context) => Column(children: [
      Text(context.readingDate(today)), Text(context.readingDate(previous)),
      Text(context.fullDate(today)),
    ]))));
    expect(find.text('Hoje'), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(3));
  });
}
