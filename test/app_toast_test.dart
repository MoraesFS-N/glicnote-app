import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/widgets/app_toast.dart';
import 'test_app.dart';

void main() {
  testWidgets('Toast replaces previous feedback, dismisses and expires above a sheet', (tester) async {
    late BuildContext page;
    await tester.pumpWidget(localizedTestApp(home: Builder(builder: (context) {
      page = context;
      return const Scaffold(body: Text('Home'));
    })));
    addTearDown(AppToast.dismiss);
    showModalBottomSheet<void>(context: page, builder: (context) => TextButton(
      onPressed: () => AppToast.show(context, 'Erro ao salvar', kind: ToastKind.error),
      child: const Text('Salvar')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Erro ao salvar').hitTestable(), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is Semantics && w.properties.liveRegion == true), findsWidgets);
    AppToast.show(page, 'Registro repetido', kind: ToastKind.warning);
    await tester.pump();
    expect(find.text('Erro ao salvar'), findsNothing);
    expect(find.text('Registro repetido'), findsOneWidget);
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pump();
    expect(find.text('Registro repetido'), findsNothing);
    AppToast.show(page, 'Salvo');
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Salvo'), findsNothing);
  });
}
