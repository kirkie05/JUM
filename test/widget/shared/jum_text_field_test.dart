import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jum/shared/widgets/jum_text_field.dart';

void main() {
  group('JumTextField Widget Tests', () {
    testWidgets('Renders label and hint correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JumTextField(
              label: 'Test Label',
              hint: 'Test Hint',
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('Shows errorText when set', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JumTextField(
              label: 'Test Label',
              errorText: 'Required Field',
            ),
          ),
        ),
      );

      expect(find.text('Required Field'), findsOneWidget);
    });

    testWidgets('obscureText hides input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JumTextField(
              label: 'Password',
              obscureText: true,
            ),
          ),
        ),
      );

      final TextField textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(JumTextField),
          matching: find.byType(TextField),
        ),
      );

      expect(textField.obscureText, isTrue);
    });
  });
}
