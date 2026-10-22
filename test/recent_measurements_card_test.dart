import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/data/glucose_entry.dart';
import 'package:glicnote_app/design_system.dart';
import 'package:glicnote_app/widgets/recent_measurements_card.dart';
import 'test_app.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('Recent columns have equal sizes and wrap without breaking at scale $scale', (tester) async {
      final entries = List.generate(4, (i) => GlucoseEntry(value: i == 0 ? 1000 : 100 + i,
        moment: 'Outro', at: DateTime(2026, 10, 22 - i, 9),
        insulinUnits: i == 0 ? 25 : i == 2 ? 99999.999 : null));
      await tester.pumpWidget(localizedTestApp(theme: GlicTheme.light,
        home: Scaffold(body: MediaQuery(data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: SingleChildScrollView(child: SizedBox(width: 320,
            child: RecentMeasurementsCard(entries: entries, onSeeAll: () {})))))));
      final columns = find.byType(MeasurementColumn);
      final firstSize = tester.getSize(columns.first);
      for (var i = 1; i < 4; i++) {
        expect(tester.getSize(columns.at(i)), firstSize);
      }
      expect(firstSize.width, scale == 1 ? 59 : 130);
      if (scale == 1) {
        expect(tester.getTopLeft(columns.last).dy, tester.getTopLeft(columns.first).dy);
      } else {
        expect(tester.getTopLeft(columns.at(2)).dy, greaterThan(tester.getTopLeft(columns.first).dy));
      }
      expect(find.text('25 UI'), findsOneWidget);
      expect(find.textContaining('de insulina'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
