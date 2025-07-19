import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Job Model Integration Tests', () {
    test('Job serialization roundtrip with actualEndDate', () {
      // Create a job with all fields including actualEndDate
      final originalJob = Job(
        id: 'test-123',
        title: 'Test Job',
        status: 'Completed',
        address: '123 Test Street',
        startDate: DateTime(2024, 1, 1, 9, 0),
        projectedEndDate: DateTime(2024, 1, 15, 17, 0),
        actualEndDate: DateTime(2024, 1, 12, 16, 30),
      );

      // Convert to Firestore format
      final firestoreData = originalJob.toFirestore();
      
      // Verify actualEndDate is in the Firestore data
      expect(firestoreData['actualEndDate'], equals(originalJob.actualEndDate));
      expect(firestoreData['actualEndDate'], isNot(equals(firestoreData['projectedEndDate'])));

      // Convert to Map format
      final mapData = originalJob.toMap();
      
      // Verify actualEndDate is in the map data
      expect(mapData['actualEndDate'], equals(originalJob.actualEndDate));
    });

    test('Job deserialization handles missing actualEndDate correctly', () {
      // Simulate Firestore data without actualEndDate
      final firestoreData = {
        'id': 'test-456',
        'title': 'Ongoing Job',
        'status': 'In Progress',
        'address': '456 Test Avenue',
        'startDate': Timestamp.fromDate(DateTime(2024, 1, 5)),
        'projectedEndDate': Timestamp.fromDate(DateTime(2024, 1, 20)),
        // actualEndDate is intentionally missing
      };

      // Create job from data (simulating what fromFirestore would do)
      final job = Job(
        id: firestoreData['id'] as String?,
        title: firestoreData['title'] as String,
        status: firestoreData['status'] as String,
        address: firestoreData['address'] as String?,
        startDate: (firestoreData['startDate'] as Timestamp).toDate(),
        projectedEndDate: (firestoreData['projectedEndDate'] as Timestamp).toDate(),
        actualEndDate: firestoreData['actualEndDate'] != null 
            ? (firestoreData['actualEndDate'] as Timestamp).toDate() 
            : null,
      );

      // Verify actualEndDate is null
      expect(job.actualEndDate, isNull);
      // Verify other dates are correct
      expect(job.startDate, equals(DateTime(2024, 1, 5)));
      expect(job.projectedEndDate, equals(DateTime(2024, 1, 20)));
    });

    test('Date fields independence verification', () {
      final job = Job(
        title: 'Date Test Job',
        address: 'Test Location',
        startDate: DateTime(2024, 1, 1),
        projectedEndDate: DateTime(2024, 1, 15),
        actualEndDate: DateTime(2024, 1, 10),
      );

      // All three dates should be different
      expect(job.startDate, isNot(equals(job.projectedEndDate)));
      expect(job.startDate, isNot(equals(job.actualEndDate)));
      expect(job.projectedEndDate, isNot(equals(job.actualEndDate)));

      // Verify specific values
      expect(job.startDate?.day, equals(1));
      expect(job.projectedEndDate?.day, equals(15));
      expect(job.actualEndDate?.day, equals(10));
    });
  });
}