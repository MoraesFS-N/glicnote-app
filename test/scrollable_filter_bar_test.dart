import 'test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/widgets/scrollable_filter_bar.dart';

void main() {
  testWidgets('More indicator advances filters and disappears at the end', (tester) async {
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: 240, child: ScrollableFilterBar(
        options: const ['Todos', 'Jejum', 'Após café', 'Após almoço', 'Após lanche'],
        selected: 'Todos',
        onSelected: (_) {},
      )),
    ))));
    await tester.pumpAndSettle();
    final indicator = find.byTooltip('Ver mais filtros à direita');
    expect(indicator, findsOneWidget);
    await tester.tap(indicator);
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, greaterThan(0));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(indicator, findsNothing);
    expect(find.text('Após lanche').hitTestable(), findsOneWidget);
    scrollable.position.jumpTo(0);
    await tester.pumpAndSettle();
    expect(indicator, findsOneWidget);
  });
}
