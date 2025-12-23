// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:registration_app/main.dart';

void main() {
  testWidgets('Registration app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RegistrationApp());

    // Verify that the personal info screen is displayed.
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text('Tell us about yourself'), findsOneWidget);
  });
}
