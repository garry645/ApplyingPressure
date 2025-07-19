import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/database_service.dart';
import 'package:applying_pressure/login/auth.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestEnvironment();
  });

  group('Singleton Pattern Tests', () {
    test('DatabaseService should return same instance', () {
      final instance1 = DatabaseService();
      final instance2 = DatabaseService();
      
      // Both instances should be identical
      expect(identical(instance1, instance2), isTrue);
      expect(instance1.hashCode, equals(instance2.hashCode));
    });

    test('DatabaseService should maintain state across instances', () {
      final instance1 = DatabaseService();
      final instance2 = DatabaseService();
      
      // Both should use the same collection names
      expect(instance1.currJobCollection, equals(instance2.currJobCollection));
      expect(instance1.currCustomerCollection, equals(instance2.currCustomerCollection));
      expect(instance1.currExpenseCollection, equals(instance2.currExpenseCollection));
    });

    test('Auth should return same instance', () {
      final auth1 = Auth();
      final auth2 = Auth();
      
      // Both instances should be identical
      expect(identical(auth1, auth2), isTrue);
      expect(auth1.hashCode, equals(auth2.hashCode));
    }, skip: 'Auth requires Firebase to be initialized');

    test('Multiple service creations should be efficient', () {
      // Measure time for first creation
      final stopwatch1 = Stopwatch()..start();
      final first = DatabaseService();
      stopwatch1.stop();
      
      // Measure time for subsequent creations
      final stopwatch2 = Stopwatch()..start();
      final second = DatabaseService();
      final third = DatabaseService();
      final fourth = DatabaseService();
      stopwatch2.stop();
      
      // Subsequent creations should be much faster
      expect(stopwatch2.elapsedMicroseconds, lessThan(stopwatch1.elapsedMicroseconds));
      
      // All should be the same instance
      expect(identical(first, second), isTrue);
      expect(identical(second, third), isTrue);
      expect(identical(third, fourth), isTrue);
    });
  });

  group('Environment Configuration Tests', () {
    test('DatabaseService should read test collections from env', () {
      final service = DatabaseService();
      
      // Should use test collections based on our test env
      expect(service.currJobCollection, equals('TestJobs'));
      expect(service.currCustomerCollection, equals('TestCustomers'));
      expect(service.currExpenseCollection, equals('TestExpenses'));
    });
  });
}