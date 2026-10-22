import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glicnote_app/main.dart';

void main() {
  testWidgets('Splash opens the glucose dashboard', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.platformDispatcher.localesTestValue = const [Locale('pt', 'BR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const GlicNoteApp());
    expect(find.byType(GlicShell), findsNothing);
    await tester.pumpAndSettle();

    expect(find.byType(GlicShell), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Começar'), findsNothing);
  });

  testWidgets('Name and email are read-only in the profile', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.platformDispatcher.localesTestValue = const [Locale('pt', 'BR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const GlicNoteApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.widgetWithText(TextFormField, 'Nome'), 150,
      scrollable: find.byType(Scrollable).hitTestable().first);
    final name = tester.widget<TextField>(find.descendant(of: find.widgetWithText(TextFormField, 'Nome'), matching: find.byType(TextField)));
    final email = tester.widget<TextField>(find.descendant(of: find.widgetWithText(TextFormField, 'E-mail'), matching: find.byType(TextField)));
    expect(name.readOnly, isTrue);
    expect(email.readOnly, isTrue);
    expect(find.text('Salvar perfil'), findsNothing);
  });
}
