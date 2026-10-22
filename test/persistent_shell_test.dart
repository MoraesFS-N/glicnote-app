import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:glicnote_app/auth/login_controller.dart';
import 'package:glicnote_app/data/api_client.dart';
import 'package:glicnote_app/data/app_repository.dart';
import 'package:glicnote_app/main.dart';
import 'test_app.dart';

void main() {
  testWidgets('A saved reading closes the sheet and returns after reopening the app', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final stored = <Map<String, dynamic>>[];
    final api = ApiClient(baseUrl: Uri.parse('http://localhost'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {},
      client: MockClient((request) async {
        if (request.url.path.endsWith('emergency-contact')) return http.Response('{}', 404);
        if (request.method == 'POST') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['timeZone'], 'America/Sao_Paulo');
          stored.add({...body, 'version': 0});
          return http.Response(jsonEncode(stored.last), 200);
        }
        return http.Response(jsonEncode({'items': stored, 'nextCursor': null}), 200);
      }));
    final repository = AppRepository(api, deviceTimeZone: () async => 'America/Sao_Paulo');
    Widget app() => localizedTestApp(home: GlicShell(repository: repository,
      profile: const LoginProfile(id: 'alice', name: 'Alice')));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Sua primeira aferição'), findsOneWidget);
    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '110');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pumpAndSettle();
    expect(find.text('Salvar medição'), findsNothing);
    expect(stored.length, 1);
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 0);
    expect(find.textContaining('Hoje'), findsWidgets);
    expect(find.text('110'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Sua primeira aferição'), findsNothing);
    expect(find.text('110'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    api.close();
  });
}
