import 'dart:async';
import 'test_app.dart';
import 'package:glicnote_app/data/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/screens.dart';
import 'package:glicnote_app/widgets/add_record_form.dart';

void main() {
  testWidgets('Two clicks before the next frame send only one request', (tester) async {
    final response = Completer<GlucoseEntry>();
    var requests = 0;
    GlucoseEntry? pending;
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: AddRecordForm(
      onCancel: () {}, onSave: (_) {},
      onPersist: (entry) { requests++; pending = entry; return response.future; },
    ))));
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '110');
    final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Salvar medição'));
    button.onPressed!();
    button.onPressed!();
    expect(requests, 1);
    await tester.pump();
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Salvar medição')).onPressed, isNull);
    response.complete(pending!);
    await tester.pumpAndSettle();
  });

  testWidgets('A second reading for the same moment today is blocked before sending', (tester) async {
    var requests = 0;
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: AddRecordForm(
      existingEntries: [GlucoseEntry(value: 94, moment: 'Jejum', at: DateTime.now())],
      onCancel: () {}, onSave: (_) {},
      onPersist: (entry) async { requests++; return entry; },
    ))));
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '150');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pumpAndSettle();
    expect(requests, 0);
    expect(find.text('Já existe uma aferição para esse momento neste dia. Confira o histórico antes de registrar novamente.'), findsOneWidget);
  });

  testWidgets('A server duplicate keeps the form open and explains the conflict', (tester) async {
    var saved = false;
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: AddRecordForm(
      onCancel: () {}, onSave: (_) => saved = true,
      onPersist: (_) async => throw const ApiFailure(409, 'duplicate_reading'),
    ))));
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '110');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pumpAndSettle();
    expect(saved, isFalse);
    expect(find.text('Já existe uma aferição para esse momento neste dia. Confira o histórico antes de registrar novamente.'), findsOneWidget);
    expect(find.text('110'), findsOneWidget);
  });

  testWidgets('Failed save keeps the draft and retries the same measurement', (tester) async {
    final attempts = <GlucoseEntry>[];
    GlucoseEntry? saved;
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: AddRecordForm(
      persistent: true, onCancel: () {}, onSave: (entry) => saved = entry,
      onPersist: (entry) async {
        attempts.add(entry);
        if (attempts.length == 1) throw Exception('offline');
        return entry;
      },
    ))));
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '110');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pumpAndSettle();
    expect(saved, isNull);
    expect(find.text('Não foi possível salvar. Confira sua conexão e tente novamente.'), findsOneWidget);
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pumpAndSettle();
    expect(attempts.length, 2);
    expect(identical(attempts[0], attempts[1]), isTrue);
    expect(saved?.value, 110);
  });

  testWidgets('Registration accepts optional insulin and decimal comma', (tester) async {
    GlucoseEntry? saved;
    await tester.pumpWidget(localizedTestApp(home: Scaffold(
      body: AddRecordForm(onSave: (entry) => saved = entry, onCancel: () {}),
    )));
    await tester.enterText(find.widgetWithText(TextFormField, 'Glicemia (mg/dL)'), '110');
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pump();
    expect(saved?.value, 110);
    expect(saved?.insulinUnits, isNull);
    final insulin = find.widgetWithText(TextFormField, 'Insulina utilizada (UI) — opcional');
    await tester.enterText(insulin, '-1');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pump();
    expect(find.text('Informe uma quantidade válida em UI.'), findsOneWidget);
    await tester.enterText(insulin, '2,5');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Salvar medição'));
    await tester.tap(find.text('Salvar medição'));
    await tester.pump();
    expect(saved?.insulinUnits, 2.5);
  });
}
