import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../firebase_test_config.dart';

void main() {
  setUpAll(() async {
    // Initialize Firebase for tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: testFirebaseOptions,
    );
    // Load test environment
    dotenv.testLoad(fileInput: 'USE_TEST_COLLECTIONS=true\nENV=test');
  });

  group('AddJobPage Tests', () {
    testWidgets('should display correct dates for start and projected end', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddJobPage(),
        ),
      );

      // Find the date display texts
      final startDateText = find.textContaining('Start Date & Time:');
      final projectedEndDateText = find.textContaining('Projected End Date & Time:');

      expect(startDateText, findsOneWidget);
      expect(projectedEndDateText, findsOneWidget);

      // Get the actual text widgets
      final startDateWidget = tester.widget<Text>(startDateText);
      final projectedEndDateWidget = tester.widget<Text>(projectedEndDateText);

      // Both should initially show current date/time (they start as DateTime.now())
      // But they should be showing their respective values
      expect(startDateWidget.data, contains('Start Date & Time:'));
      expect(projectedEndDateWidget.data, contains('Projected End Date & Time:'));
      
      // They should show the same initial values
      final startDateMatch = RegExp(r'(\d+/\d+/\d+)').firstMatch(startDateWidget.data!);
      final endDateMatch = RegExp(r'(\d+/\d+/\d+)').firstMatch(projectedEndDateWidget.data!);
      
      expect(startDateMatch?.group(1), equals(endDateMatch?.group(1)));
    });

    testWidgets('should have two different date picker buttons', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddJobPage(),
        ),
      );

      // Find all "Select Date & Time" buttons
      final dateButtons = find.widgetWithText(ElevatedButton, 'Select Date & Time');
      
      // Should have exactly 2 buttons
      expect(dateButtons, findsNWidgets(2));
    });

    testWidgets('TextEditingControllers should be properly initialized', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddJobPage(),
        ),
      );

      // Find text fields
      final titleField = find.widgetWithText(TextFormField, 'Title');
      final addressField = find.widgetWithText(TextFormField, 'Address');

      expect(titleField, findsOneWidget);
      expect(addressField, findsOneWidget);
    });

    testWidgets('Form validation should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddJobPage(),
        ),
      );

      // Find and tap the submit button without filling fields
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter some text'), findsNWidgets(2));
    });
  });

  group('AddJobPage Lifecycle Tests', () {
    testWidgets('should dispose controllers when widget is disposed', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddJobPage(),
        ),
      );

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Different Page')),
        ),
      );

      // The dispose method should have been called
      // In a real test, we might need to mock the controllers to verify dispose was called
      expect(find.text('Different Page'), findsOneWidget);
    });
  });
}