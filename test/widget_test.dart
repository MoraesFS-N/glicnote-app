import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/main.dart';

void main() {
  testWidgets('Splash opens the glucose dashboard', (tester) async {
    await tester.pumpWidget(const GlicNoteApp());
    expect(find.text('Começar'), findsOneWidget);

    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    expect(find.byType(GlicShell), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Começar'), findsNothing);
  });
}
