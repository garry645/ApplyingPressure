import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Job Model Tests', () {
    test('fromFirestore should correctly parse actualEndDate when present', () {
      // Create mock data with actualEndDate
      final mockData = {
        'id': 'test-id',
        'title': 'Test Job',
        'status': 'In Progress',
        'address': '123 Test St',
        'startDate': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'projectedEndDate': Timestamp.fromDate(DateTime(2024, 1, 15)),
        'actualEndDate': Timestamp.fromDate(DateTime(2024, 1, 10)),
      };

      // Create a mock DocumentSnapshot
      final job = Job(
        id: mockData['id'] as String,
        title: mockData['title'] as String,
        status: mockData['status'] as String,
        address: mockData['address'] as String,
        startDate: (mockData['startDate'] as Timestamp).toDate(),
        projectedEndDate: (mockData['projectedEndDate'] as Timestamp).toDate(),
        actualEndDate: mockData['actualEndDate'] != null 
            ? (mockData['actualEndDate'] as Timestamp).toDate() 
            : null,
      );

      // Verify actualEndDate is correctly parsed
      expect(job.actualEndDate, equals(DateTime(2024, 1, 10)));
      expect(job.projectedEndDate, equals(DateTime(2024, 1, 15)));
      expect(job.actualEndDate, isNot(equals(job.projectedEndDate)));
    });

    test('fromFirestore should handle null actualEndDate', () {
      // Create mock data without actualEndDate
      final mockData = {
        'id': 'test-id',
        'title': 'Test Job',
        'status': 'Pending',
        'address': '123 Test St',
        'startDate': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'projectedEndDate': Timestamp.fromDate(DateTime(2024, 1, 15)),
        // actualEndDate is not included
      };

      final job = Job(
        id: mockData['id'] as String,
        title: mockData['title'] as String,
        status: mockData['status'] as String,
        address: mockData['address'] as String,
        startDate: (mockData['startDate'] as Timestamp).toDate(),
        projectedEndDate: (mockData['projectedEndDate'] as Timestamp).toDate(),
        actualEndDate: mockData['actualEndDate'] != null 
            ? (mockData['actualEndDate'] as Timestamp).toDate() 
            : null,
      );

      // Verify actualEndDate is null
      expect(job.actualEndDate, isNull);
      expect(job.projectedEndDate, equals(DateTime(2024, 1, 15)));
    });

    test('toFirestore should include all fields when present', () {
      final job = Job(
        id: 'test-id',
        title: 'Test Job',
        status: 'Completed',
        address: '123 Test St',
        startDate: DateTime(2024, 1, 1),
        projectedEndDate: DateTime(2024, 1, 15),
        actualEndDate: DateTime(2024, 1, 10),
      );

      final firestoreData = job.toFirestore();

      expect(firestoreData['id'], equals('test-id'));
      expect(firestoreData['title'], equals('Test Job'));
      expect(firestoreData['status'], equals('Completed'));
      expect(firestoreData['address'], equals('123 Test St'));
      expect(firestoreData['startDate'], equals(DateTime(2024, 1, 1)));
      expect(firestoreData['projectedEndDate'], equals(DateTime(2024, 1, 15)));
      expect(firestoreData['actualEndDate'], equals(DateTime(2024, 1, 10)));
    });

    test('toMap should include actualEndDate', () {
      final job = Job(
        id: 'test-id',
        title: 'Test Job',
        status: 'Completed',
        address: '123 Test St',
        startDate: DateTime(2024, 1, 1),
        projectedEndDate: DateTime(2024, 1, 15),
        actualEndDate: DateTime(2024, 1, 10),
      );

      final mapData = job.toMap();

      expect(mapData['actualEndDate'], equals(DateTime(2024, 1, 10)));
      expect(mapData['projectedEndDate'], equals(DateTime(2024, 1, 15)));
    });
  });
}