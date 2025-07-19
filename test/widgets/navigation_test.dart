import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:applying_pressure/customers/customers_list_page.dart';
import 'package:applying_pressure/expenses/expenses_list_page.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/customers/add_customer_page.dart';
import 'package:applying_pressure/expenses/add_expense_page.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/expenses/expense.dart';
import 'package:applying_pressure/routes.dart';
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
    
    // Add some mock data to prevent empty states
    services.databaseService.addTestJob(Job(
      id: '1',
      title: 'Test Job',
      address: '123 Test St',
      startDate: DateTime.now(),
      projectedEndDate: DateTime.now().add(const Duration(days: 7)),
    ));
    services.databaseService.addTestCustomer(Customer(
      id: '1',
      name: 'Test Customer',
      address: '123 Test St',
      sourceOfLead: 'Test',
      phoneNumber: '555-1234',
      potentialCustomers: [],
    ));
    services.databaseService.addTestExpense(Expense(
      id: '1',
      name: 'Test Expense',
      cost: 100.0,
      description: 'Test Description',
    ));
  });

  tearDown(() {
    services.dispose();
  });

  group('Navigation Tests', () {
    testWidgets('Jobs add button should navigate to AddJobPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MaterialApp(
            home: const JobsListPage(),
            routes: {
              Routes.addJob: (context) => const AddJobPage(),
            },
          ),
          authService: services.authService,
          databaseService: services.databaseService,
        ),
      );

      // Wait for the page to load with a timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the add button
      final addButton = find.byType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify we navigated to the AddJobPage
      expect(find.byType(AddJobPage), findsOneWidget);
    });

    testWidgets('Customers add button should navigate to AddCustomerPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MaterialApp(
            home: const CustomersListPage(),
            routes: {
              Routes.addCustomer: (context) => const AddCustomerPage(),
            },
          ),
          authService: services.authService,
          databaseService: services.databaseService,
        ),
      );

      // Wait for the page to load with a timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the add button
      final addButton = find.byType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify we navigated to the AddCustomerPage
      expect(find.byType(AddCustomerPage), findsOneWidget);
    });

    testWidgets('Expenses add button should navigate to AddExpensePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MaterialApp(
            home: const ExpensesListPage(),
            routes: {
              Routes.addExpense: (context) => const AddExpensePage(),
            },
          ),
          authService: services.authService,
          databaseService: services.databaseService,
        ),
      );

      // Wait for the page to load with a timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the add button
      final addButton = find.byType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify we navigated to the AddExpensePage
      expect(find.byType(AddExpensePage), findsOneWidget);
    });

    testWidgets('Route constants should match page route names',
        (WidgetTester tester) async {
      // Verify that our route constants match what's defined in the pages
      expect(AddJobPage.routeName, equals(Routes.addJob));
      expect(AddCustomerPage.routeName, equals(Routes.addCustomer));
      expect(AddExpensePage.routeName, equals(Routes.addExpense));
    });
  });

  group('Named Routes Configuration', () {
    testWidgets('All routes should be properly configured in main app',
        (WidgetTester tester) async {
      // Create a test app with all routes configured
      await tester.pumpWidget(
        createTestWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Column(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.addJob),
                      child: const Text('Add Job'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.addCustomer),
                      child: const Text('Add Customer'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.addExpense),
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ),
            ),
            routes: {
              Routes.addJob: (context) => const AddJobPage(),
              Routes.addCustomer: (context) => const AddCustomerPage(),
              Routes.addExpense: (context) => const AddExpensePage(),
            },
          ),
          authService: services.authService,
          databaseService: services.databaseService,
        ),
      );

      // Test navigation to AddJobPage
      await tester.tap(find.text('Add Job'));
      await tester.pumpAndSettle();
      expect(find.byType(AddJobPage), findsOneWidget);
      Navigator.of(tester.element(find.byType(AddJobPage))).pop();
      await tester.pumpAndSettle();

      // Test navigation to AddCustomerPage
      await tester.tap(find.text('Add Customer'));
      await tester.pumpAndSettle();
      expect(find.byType(AddCustomerPage), findsOneWidget);
      Navigator.of(tester.element(find.byType(AddCustomerPage))).pop();
      await tester.pumpAndSettle();

      // Test navigation to AddExpensePage
      await tester.tap(find.text('Add Expense'));
      await tester.pumpAndSettle();
      expect(find.byType(AddExpensePage), findsOneWidget);
    });
  });
}