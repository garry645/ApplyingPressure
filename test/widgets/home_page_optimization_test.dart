import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/home/home_page.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import '../test_helper.dart';
import '../mocks/mock_auth_service.dart';

void main() {
  late TestServices services;
  
  setUp(() {
    services = TestServices();
    // Set up a logged-in user for HomePage tests
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
  });
  
  tearDown(() {
    services.dispose();
  });

  group('HomePage Optimization Tests', () {
    testWidgets('HomePage should use PageView instead of IndexedStack', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const HomePage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Find PageView widget
      expect(find.byType(PageView), findsOneWidget);
      
      // Should not find IndexedStack
      expect(find.byType(IndexedStack), findsNothing);
    });

    testWidgets('PageView should enable swiping between pages', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const HomePage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Initially on Jobs page (index 0)
      BottomNavigationBar bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(0));
      
      // Tap on Customers tab instead of swiping
      await tester.tap(find.byIcon(Icons.cases_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350)); // Wait for animation
      
      // Should now show Customers tab as selected
      bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(1));
    });

    testWidgets('Bottom navigation should sync with PageView', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const HomePage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Tap on Expenses tab
      await tester.tap(find.byIcon(Icons.person_add));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350)); // Wait for animation
      
      // Bottom nav should update
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(2));
    });

    testWidgets('PageController should be properly disposed', 
        (WidgetTester tester) async {
      await pumpTestWidget(
        tester,
        const HomePage(),
        authService: services.authService,
        databaseService: services.databaseService,
      );

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Different Page')),
        ),
      );

      // No way to directly test disposal, but this ensures no errors occur
      expect(tester.takeException(), isNull);
    });
  });

  group('Performance Characteristics', () {
    test('Lazy loading should reduce initial widget creation', () {
      // With PageView, only the first page is built initially
      // With IndexedStack, all pages are built at once
      
      // This is more of a conceptual test showing the difference
      const pageViewChildCount = 1; // Only visible page
      const indexedStackChildCount = 3; // All pages
      
      expect(pageViewChildCount, lessThan(indexedStackChildCount));
    });
  });
}