import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:glicnote_app/auth/login_controller.dart';
import 'package:glicnote_app/data/api_client.dart';
import 'package:glicnote_app/data/app_repository.dart';
import 'package:glicnote_app/main.dart';
import 'package:glicnote_app/screens/complete_profile_screen.dart';
import 'test_app.dart';

void main() {
  test('Age changes on the birthday and is unknown without a full date', () {
    final profile = LoginProfile(id: 'alice', name: 'Alice', birthDate: DateTime(2000, 10, 22));
    expect(profile.ageAt(DateTime(2026, 10, 21)), 25);
    expect(profile.ageAt(DateTime(2026, 10, 22)), 26);
    expect(profile.ageAt(DateTime(2026, 10, 23)), 26);
    expect(const LoginProfile(id: 'a', name: 'A', birthdayMonth: 10, birthdayDay: 22).ageAt(DateTime(2026)), isNull);
    final leap = LoginProfile(id: 'a', name: 'A', birthDate: DateTime(2000, 2, 29), diabetesType: 'type_1');
    expect(leap.ageAt(DateTime(2025, 2, 28)), 24);
    expect(leap.ageAt(DateTime(2025, 3, 1)), 25);
  });

  test('The update sends the full date and preserves Google identity', () async {
    final api = ApiClient(baseUrl: Uri.parse('https://api.example.test'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {}, client: MockClient((request) async {
        final body = jsonDecode(request.body);
        expect(body['diabetesType'], 'type_1');
        expect(body['birthDate'], '2000-02-29');
        expect(body['birthdayMonth'], 2);expect(body['birthdayDay'], 29);
        expect(body['name'], 'Alice');expect(body.containsKey('email'), isFalse);
        return http.Response('{"id":"alice","name":"Alice","birthDate":"2000-02-29","diabetesType":"type_1"}', 200);
      }));
    final saved = await AppRepository(api).saveProfile(const LoginProfile(id: 'alice', name: 'Alice'),
      'alice', timeZone: 'America/Sao_Paulo', birthDate: DateTime(2000, 2, 29), diabetesType: 'type_1');
    expect(saved.birthDate, DateTime(2000, 2, 29));
    expect(saved.diabetesType, 'type_1');api.close();
  });

  test('A legacy month/day birthday survives completion without an invented year', () async {
    final api = ApiClient(baseUrl: Uri.parse('https://api.example.test'), userId: () => 'alice',
      accessToken: () => 'token', refreshSession: () async {}, client: MockClient((request) async {
        final body = jsonDecode(request.body);
        expect(body['birthDate'], isNull);
        expect(body['birthdayMonth'], 10);expect(body['birthdayDay'], 22);
        return http.Response('{"id":"alice","name":"Alice","birthdayMonth":10,"birthdayDay":22}', 200);
      }));
    await AppRepository(api).saveProfile(const LoginProfile(id: 'alice', name: 'Alice',
      birthdayMonth: 10, birthdayDay: 22), 'alice', timeZone: 'UTC');
    api.close();
  });

  testWidgets('The completion link opens another screen and updates the profile after saving', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(localizedTestApp(home: const GlicShell(
      profile: LoginProfile(id: 'alice', name: 'Alice', email: 'alice@example.com'))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete seu cadastro'));
    await tester.pumpAndSettle();
    expect(find.byType(CompleteProfileScreen), findsOneWidget);
    expect(tester.widget<TextField>(find.descendant(of: find.widgetWithText(TextFormField, 'Nome'), matching: find.byType(TextField))).readOnly, isTrue);
    expect(tester.widget<TextField>(find.descendant(of: find.widgetWithText(TextFormField, 'E-mail'), matching: find.byType(TextField))).readOnly, isTrue);
    await tester.scrollUntilVisible(find.widgetWithText(TextFormField, 'Nome de usuário'), 200,
      scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).last);
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome de usuário'), 'alice');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipo 1').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(TextFormField, 'Data de nascimento — opcional'));
    await tester.tap(find.widgetWithText(TextFormField, 'Data de nascimento — opcional'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(DatePickerDialog))).pop(DateTime(2000, 10, 22));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Salvar perfil'));
    await tester.tap(find.text('Salvar perfil'));
    await tester.pumpAndSettle();
    expect(find.byType(CompleteProfileScreen), findsNothing);
    expect(find.text('Complete seu cadastro'), findsNothing);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('Tipo de diabetes: Tipo 1'), findsOneWidget);
    expect(find.text('Alice'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Dados complementares'), 200,
      scrollable: find.byType(Scrollable).hitTestable().first);
    expect(find.text('Dados complementares'), findsOneWidget);
  });
}
