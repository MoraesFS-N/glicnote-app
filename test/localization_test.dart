import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/main.dart';

void main() {
  for (final entry in <String, List<String>>{
    'pt': ['Início', 'Registrar', 'Nova medição', 'Jejum', 'Insulina utilizada (UI) — opcional'],
    'en': ['Home', 'Record', 'New reading', 'Fasting', 'Insulin used (IU) — optional'],
    'es': ['Inicio', 'Registrar', 'Nueva medición', 'En ayunas', 'Insulina utilizada (UI) — opcional'],
    'fr': ['Home', 'Record', 'New reading', 'Fasting', 'Insulin used (IU) — optional'],
  }.entries) {
    testWidgets('Device language ${entry.key} localizes navigation and registration', (tester) async {
      tester.platformDispatcher.localesTestValue = [Locale(entry.key)];
      tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
      await tester.pumpWidget(const GlicNoteApp());
      await tester.pumpAndSettle();
      expect(find.text(entry.value[0]), findsOneWidget);
      await tester.tap(find.text(entry.value[1]));
      await tester.pumpAndSettle();
      expect(find.text(entry.value[2]), findsOneWidget);
      expect(find.text(entry.value[3]).hitTestable(), findsOneWidget);
      expect(find.widgetWithText(TextFormField, entry.value[4]), findsOneWidget);
    });
  }

  testWidgets('Changing device locale updates an already open screen', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(const GlicNoteApp());
    await tester.pumpAndSettle();
    expect(find.text('Fasting'), findsOneWidget);
    tester.platformDispatcher.localesTestValue = const [Locale('es', 'ES')];
    await tester.pumpAndSettle();
    expect(find.text('En ayunas'), findsOneWidget);
    expect(find.text('Fasting'), findsNothing);
  });
}
