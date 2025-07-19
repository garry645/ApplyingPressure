import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/customers/customer.dart';
import '../test_helper.dart';

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

  group('AddJobPage with Customer', () {
    testWidgets('should pre-fill address when customer is provided', 
        (WidgetTester tester) async {
      final customer = Customer(
        id: 'cust-123',
        name: 'John Doe',
        address: '456 Customer Street',
        phoneNumber: '555-9999',
        sourceOfLead: 'Referral',
        potentialCustomers: [],
      );

      await tester.pumpWidget(
        createTestWidget(
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => const AddJobPage(),
                settings: RouteSettings(arguments: customer),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the address field
      final addressField = find.widgetWithText(TextFormField, 'Enter Job Address');
      expect(addressField, findsOneWidget);

      // Check that the controller has the customer's address
      final textFormField = tester.widget<TextFormField>(addressField);
      expect(textFormField.controller?.text, equals('456 Customer Street'));
    });

    testWidgets('should work without customer (normal add job flow)', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const AddJobPage()),
      );

      await tester.pumpAndSettle();

      // Find the address field
      final addressField = find.widgetWithText(TextFormField, 'Enter Job Address');
      expect(addressField, findsOneWidget);

      // Check that the controller is empty or null
      final textFormField = tester.widget<TextFormField>(addressField);
      expect(textFormField.controller?.text ?? '', equals(''));
    });
  });
}