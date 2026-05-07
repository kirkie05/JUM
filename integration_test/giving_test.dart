import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jum/features/giving/presentation/screens/giving_screens.dart';
import 'package:jum/shared/widgets/jum_button.dart';
import 'package:jum/shared/widgets/jum_text_field.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('GiveScreen Integration Test - Loads, selects category, inputs custom amount', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GiveScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify screen loads with title
    expect(find.text('Online Giving'), findsOneWidget);

    // Verify Tithe is the default selected category
    expect(find.text('Tithe'), findsAtLeastNWidgets(1));

    // Tap the dropdown to change category
    await tester.tap(find.text('Tithe').first);
    await tester.pumpAndSettle();

    // Select 'Missions' from dropdown list
    await tester.tap(find.text('Missions').last);
    await tester.pumpAndSettle();

    // Select "Custom" amount button
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    // Verify Custom amount text field is displayed
    expect(find.byType(JumTextField), findsOneWidget);

    // Enter custom amount (e.g., "250")
    await tester.enterText(find.byType(TextField), '250');
    await tester.pumpAndSettle();

    // Verify text field contains 250
    expect(find.text('250'), findsOneWidget);

    // Verify contribution button is available
    expect(find.byType(JumButton), findsOneWidget);
  });
}
