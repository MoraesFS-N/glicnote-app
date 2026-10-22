import 'test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/design_system.dart';
import 'package:glicnote_app/widgets/glucose_summary_card.dart';

void main() {
  testWidgets('Summary accepts values and adapts to narrow layouts with large text', (tester) async {
    await tester.pumpWidget(localizedTestApp(
      theme: GlicTheme.light,
      home: Scaffold(body: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: const SingleChildScrollView(child: SizedBox(
          width: 280,
          child: GlucoseSummaryCard(value: 123, detail: 'Hoje às 08:00', insulinUnits: 2.5),
        )),
      )),
    ));
    expect(find.text('Hoje às 08:00'), findsOneWidget);
    expect(find.textContaining('123', findRichText: true), findsOneWidget);
    expect(find.textContaining('2,5', findRichText: true), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
