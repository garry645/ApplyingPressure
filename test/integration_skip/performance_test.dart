import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/services/interfaces/database_service_interface.dart';
import 'package:applying_pressure/customers/customer.dart';
import '../test_helper.dart';
import '../mocks/mock_database_service.dart';

void main() {
  setUpAll(() async {
    await initializeTestEnvironment();
  });

  group('Performance Integration Tests', () {
    test('Service creation should be efficient', () async {
      final times = <int>[];
      
      // Time multiple service creations
      for (int i = 0; i < 5; i++) {
        final stopwatch = Stopwatch()..start();
        final service = MockDatabaseService();
        stopwatch.stop();
        times.add(stopwatch.elapsedMicroseconds);
        service.dispose();
      }
      
      // Mock services should be created quickly
      for (final time in times) {
        expect(time, lessThan(1000)); // Should be under 1ms
      }
    });

    test('Mock database should handle streams efficiently', () async {
      final service = MockDatabaseService();
      
      // Listen to stream first
      var eventCount = 0;
      final stream = service.retrieveCustomers();
      final subscription = stream.listen((event) {
        eventCount++;
      });
      
      // Add test data after listener is set up
      service.addTestCustomer(Customer(
        id: '1',
        name: 'Test Customer',
        address: '123 Test St',
        sourceOfLead: 'Test',
        phoneNumber: '555-1234',
        potentialCustomers: [],
      ));
      
      // Give it time to emit
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Should have received at least one event
      expect(eventCount, greaterThan(0));
      
      await subscription.cancel();
      service.dispose();
    });
  });

  group('Memory Efficiency Tests', () {
    test('Mock service should handle multiple instances efficiently', () {
      final services = <MockDatabaseService>[];
      
      // Create multiple services
      for (int i = 0; i < 10; i++) {
        services.add(MockDatabaseService());
      }
      
      // Each mock is independent
      final hashes = services.map((s) => s.hashCode).toSet();
      expect(hashes.length, equals(10));
      
      // Clean up
      for (final service in services) {
        service.dispose();
      }
    });

    test('Mock service should maintain consistent collection names', () {
      final service = MockDatabaseService();
      
      // Check collection names
      expect(service.currJobCollection, equals('MockJobs'));
      expect(service.currCustomerCollection, equals('MockCustomers'));
      expect(service.currExpenseCollection, equals('MockExpenses'));
      
      service.dispose();
    });
  });
}