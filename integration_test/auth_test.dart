import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jum/main.dart' as app;
import 'package:jum/features/auth/presentation/screens/auth_screens.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash → Sign In → Onboarding flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Verify splash screen shows
    expect(find.text('JUM'), findsOneWidget);
    
    // Settle for splash duration transition (2.5 seconds + buffer)
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // Verify navigated to sign-in (no auth initially)
    expect(find.byType(SignInScreen), findsOneWidget);
  });
}
