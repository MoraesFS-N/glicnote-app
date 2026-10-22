import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/auth/login_controller.dart';
import 'package:glicnote_app/screens.dart';
import 'package:glicnote_app/screens/privacy_policy_screen.dart';
import 'package:glicnote_app/widgets/user_avatar.dart';
import 'test_app.dart';

void main() {
  test('Profile reads the photo returned by the API', () {
    final profile = LoginProfile.fromJson({'id': 'alice', 'name': 'Alice',
      'photoUrl': 'https://lh3.googleusercontent.com/photo'});
    expect(profile.photoUrl, 'https://lh3.googleusercontent.com/photo');
  });

  testWidgets('An unavailable or insecure avatar keeps the fallback visible', (tester) async {
    await tester.pumpWidget(localizedTestApp(home: const UserAvatar(photoUrl: 'http://example.test/photo')));
    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    await tester.pumpWidget(localizedTestApp(home: const UserAvatar(photoUrl: 'https://example.test/unavailable')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('The profile opens the policy without requiring a remote page', (tester) async {
    await tester.pumpWidget(localizedTestApp(home: const Scaffold(body: ProfileScreen())));
    await tester.scrollUntilVisible(find.text('Política de privacidade').hitTestable(), 150,
      scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Política de privacidade'));
    await tester.pumpAndSettle();
    expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    expect(find.textContaining('preliminar'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('A Tech Mow'), 200,
      scrollable: find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).last);
    expect(find.textContaining('A Tech Mow'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
