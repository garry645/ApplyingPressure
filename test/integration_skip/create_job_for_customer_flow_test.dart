import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/customers/customer.dart';
import '../test_helper.dart';
import '../mocks/mock_database_service.dart';

// Skip these tests as they are slow integration tests
@Skip('Integration tests are slow and should be run separately')
void main() {
  late TestServices services;

  setUpAll(() async {
    await initializeTestEnvironment();
  });

  setUp(() {
    services = TestServices();
  });

  tearDown(() {
    services.dispose();
  });

  group('Create Job for Customer Flow', () {
    testWidgets('should create job with customer reference', 
        (WidgetTester tester) async {
      final customer = Customer(
        id: 'cust-123',
        name: 'Test Customer',
        address: '789 Customer Lane',
        phoneNumber: '555-0000',
        sourceOfLead: 'Website',
        potentialCustomers: [],
      );

      final mockDb = services.databaseService as MockDatabaseService;

      // Create a simple test that doesn't involve complex navigation
      await pumpTestWidget(
        tester,
        Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const AddJobPage(),
            settings: RouteSettings(arguments: customer),
          ),
        ),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Verify address is pre-filled
      final addressField = find.widgetWithText(TextFormField, 'Enter Job Address');
      final textFormField = tester.widget<TextFormField>(addressField);
      expect(textFormField.controller?.text, equals('789 Customer Lane'));

      // Fill in the job title
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Job Title'),
        'Fix Kitchen Sink',
      );

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pump(); // Process the tap
      
      // Just verify the job was created with correct data
      // Don't wait for navigation which makes the test slow
      final jobs = await mockDb.retrieveJobs().first;
      expect(jobs.length, equals(1));
      
      final createdJob = jobs.first;
      expect(createdJob.title, equals('Fix Kitchen Sink'));
      expect(createdJob.address, equals('789 Customer Lane'));
      expect(createdJob.customerId, equals('cust-123'));
    });

    testWidgets('should handle job creation without customer', 
        (WidgetTester tester) async {
      final mockDb = services.databaseService as MockDatabaseService;
      
      await pumpTestWidget(
        tester,
        const AddJobPage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Fill in job details
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Job Title'),
        'General Maintenance',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Job Address'),
        '456 Work Street',
      );

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Verify job was created without customer reference
      final jobs = await mockDb.retrieveJobs().first;
      expect(jobs.length, equals(1));
      
      final createdJob = jobs.first;
      expect(createdJob.title, equals('General Maintenance'));
      expect(createdJob.address, equals('456 Work Street'));
      expect(createdJob.customerId, isNull);
    });
  });
}