import 'test_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glicnote_app/widgets/emergency_contact_fields.dart';

void main() {
  testWidgets('Emergency contact is optional and validates partial entries', (tester) async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final relationship = TextEditingController();
    addTearDown(name.dispose);
    addTearDown(phone.dispose);
    addTearDown(relationship.dispose);
    final form = GlobalKey<FormState>();
    await tester.pumpWidget(localizedTestApp(home: Scaffold(body: Form(
      key: form,
      child: EmergencyContactFields(name: name, phone: phone, relationship: relationship),
    ))));
    expect(form.currentState!.validate(), isTrue);
    name.text = 'Ana';
    expect(form.currentState!.validate(), isFalse);
    phone.text = '(11) 99999-1234';
    expect(form.currentState!.validate(), isTrue);
    name.clear();
    expect(form.currentState!.validate(), isFalse);
    await tester.pump();
  });
}
