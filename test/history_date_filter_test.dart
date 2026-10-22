import 'test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/screens.dart';

void main() {
  testWidgets('Date range includes the last day and combines with moment filter', (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: HistoryScreen(records: [
      GlucoseEntry(value: 91, moment: 'Jejum', at: DateTime(2026, 10, 20, 7)),
      GlucoseEntry(value: 121, moment: 'Após café', at: DateTime(2026, 10, 20, 23, 59)),
      GlucoseEntry(value: 95, moment: 'Jejum', at: DateTime(2026, 10, 19, 7)),
    ]))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filtrar por data'));
    await tester.pumpAndSettle();
    // Deliver the calendar result to exercise range application in the screen.
    Navigator.of(tester.element(find.byType(DateRangePickerDialog))).pop(
      DateTimeRange(start: DateTime(2026, 10, 20), end: DateTime(2026, 10, 20)));
    await tester.pumpAndSettle();
    expect(find.text('2 registros'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Jejum'));
    await tester.pumpAndSettle();
    expect(find.text('1 registro'), findsOneWidget);
    await tester.tap(find.text('Limpar período'));
    await tester.pumpAndSettle();
    expect(find.text('2 registros'), findsOneWidget);
  });
}
