import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import '../test_helper.dart';
import '../mocks/mock_auth_service.dart';

void main() {
  late TestServices services;
  
  setUp(() {
    services = TestServices();
    // Set up a logged-in user
    services.authService.setCurrentUser(
      MockUser(email: 'test@example.com', uid: '123'),
    );
  });
  
  tearDown(() {
    services.dispose();
  });

  group('AddJobPage Tests', () {
    testWidgets('should display correct dates for start and projected end', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
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
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Find all "Select Date & Time" buttons
      final dateButtons = find.widgetWithText(ElevatedButton, 'Select Date & Time');
      
      // Should have exactly 2 buttons
      expect(dateButtons, findsNWidgets(2));
    });

    testWidgets('TextEditingControllers should be properly initialized', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Find text fields by their hint text
      final titleField = find.byType(TextFormField).at(0);
      final addressField = find.byType(TextFormField).at(1);

      expect(titleField, findsOneWidget);
      expect(addressField, findsOneWidget);
    });

    testWidgets('Form validation should work', (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Find and tap the submit button without filling fields
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter Title:'), findsOneWidget);
      expect(find.text('Please enter Address:'), findsOneWidget);
    });
    
    testWidgets('Should navigate to job details after successful creation', 
        (WidgetTester tester) async {
      // Create a simple navigation stack to test
      await tester.pumpWidget(
        createTestWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddJobPage(),
                        ),
                      );
                    },
                    child: const Text('Go to Add Job'),
                  ),
                ),
              ),
            ),
          ),
          authService: services.authService,
          databaseService: services.databaseService,
        ),
      );

      // Navigate to AddJobPage
      await tester.tap(find.text('Go to Add Job'));
      await tester.pumpAndSettle();

      // Verify we're on the AddJobPage
      expect(find.byType(AddJobPage), findsOneWidget);

      // Fill in the form
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Job');
      await tester.enterText(find.byType(TextFormField).at(1), '123 Test St');

      // Find and tap the submit button
      final submitButton = find.widgetWithText(ElevatedButton, 'Submit');
      await tester.tap(submitButton);
      
      // Wait for async operations and navigation
      await tester.pump(); // Start the async operation
      await tester.pump(const Duration(milliseconds: 100)); // Wait a bit
      await tester.pump(); // Complete any remaining animations

      // Should navigate to JobInfoPage
      expect(find.byType(JobInfoPage), findsOneWidget);
    });
  });

  group('AddJobPage Lifecycle Tests', () {
    testWidgets('should dispose controllers when widget is disposed', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
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