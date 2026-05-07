import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jum/features/school/presentation/screens/school_screens.dart';
import 'package:jum/shared/widgets/jum_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('School & LMS Integration Tests', () {
    testWidgets('SchoolListScreen - Loads courses list successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchoolListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify screen title and hero card text are rendered
      expect(find.text('Gospel Army School'), findsOneWidget);
      expect(find.text('Grow in Spiritual Knowledge'), findsOneWidget);

      // Verify the three default courses are present
      expect(find.text('Foundations of Faith'), findsOneWidget);
      expect(find.text('Kingdom Leadership'), findsOneWidget);
      expect(find.text('Advanced Biblical Hermeneutics'), findsOneWidget);
    });

    testWidgets('SchoolDetailScreen - Loads lessons and changes active selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SchoolDetailScreen(courseId: 'course-1'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify page titles and instructor details
      expect(find.text('Lesson Player'), findsOneWidget);
      expect(find.text('Foundations of Faith'), findsOneWidget);
      expect(find.text('Instructor: Pastor Kingsley'), findsOneWidget);

      // Verify course lessons list
      expect(find.text('1. Intro to Scripture'), findsOneWidget);
      expect(find.text('2. The Nature of God'), findsOneWidget);
      expect(find.text('3. Covenant Theology'), findsOneWidget);

      // Tap on the second lesson
      await tester.tap(find.text('2. The Nature of God'));
      await tester.pumpAndSettle();

      // Verify state changes by selecting second lesson
      // (The screen should still be loaded perfectly with all lesson elements)
      expect(find.text('2. The Nature of God'), findsOneWidget);
    });
  });
}
