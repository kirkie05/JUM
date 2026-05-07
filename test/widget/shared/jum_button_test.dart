import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jum/shared/widgets/jum_button.dart';
import 'package:jum/core/constants/app_colors.dart';

void main() {
  group('JumButton Widget Tests', () {
    testWidgets('Primary variant renders with accent background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JumButton(
              label: 'Test Button',
              onPressed: () {},
              variant: JumButtonVariant.primary,
            ),
          ),
        ),
      );

      // Verify the button text is found
      expect(find.text('Test Button'), findsOneWidget);

      // Verify it contains an ElevatedButton
      final elevatedButtonFinder = find.byType(ElevatedButton);
      expect(elevatedButtonFinder, findsOneWidget);

      // Verify style/backgroundColor is correct
      final ElevatedButton button = tester.widget<ElevatedButton>(elevatedButtonFinder);
      final style = button.style;
      final backgroundColor = style?.backgroundColor?.resolve({});
      expect(backgroundColor, AppColors.accent);
    });

    testWidgets('isLoading shows CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JumButton(
              label: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Verify the CircularProgressIndicator is rendered
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify text is not visible when loading
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('isFullWidth fills width (has double.infinity width Box)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JumButton(
              label: 'Test Button',
              onPressed: () {},
              isFullWidth: true,
            ),
          ),
        ),
      );

      final SizedBox sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('onPressed null -> button disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JumButton(
              label: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final ElevatedButton button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });
  });
}
