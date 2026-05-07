import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jum/app.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: JumApp(),
      ),
    );

    // Verify that our app builds successfully without throwing on the first frame.
    expect(find.byType(JumApp), findsOneWidget);
  });
}
