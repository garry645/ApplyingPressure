import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/expenses/expense.dart';

// Simple mock implementation for DocumentSnapshot
class TestDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;
  final bool _exists;

  TestDocumentSnapshot({
    required String id,
    Map<String, dynamic>? data,
    bool exists = true,
  })  : _id = id,
        _data = data,
        _exists = exists;

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  bool get exists => _exists;

  @override
  dynamic operator [](Object field) => _data?[field];

  @override
  dynamic get(Object field) => _data?[field];

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  DocumentReference<Map<String, dynamic>> get reference => throw UnimplementedError();
}

void main() {
  group('Model ID Handling Tests', () {
    test('Customer.fromFirestore should use snapshot.id not data id', () {
      final snapshot = TestDocumentSnapshot(
        id: 'customer123',
        data: {
          'name': 'John Doe',
          'address': '123 Main St',
          'phoneNumber': '555-1234',
          'sourceOfLead': 'Website',
          // Note: no 'id' field in data
        },
      );

      final customer = Customer.fromFirestore(snapshot, null);

      expect(customer.id, 'customer123');
      expect(customer.name, 'John Doe');
      expect(customer.address, '123 Main St');
      expect(customer.phoneNumber, '555-1234');
      expect(customer.sourceOfLead, 'Website');
    });

    test('Customer.fromFirestore should handle null fields gracefully', () {
      final snapshot = TestDocumentSnapshot(
        id: 'customer456',
        data: {
          'name': null,
          'address': null,
          'phoneNumber': null,
          'sourceOfLead': null,
        },
      );

      final customer = Customer.fromFirestore(snapshot, null);

      expect(customer.id, 'customer456');
      expect(customer.name, ''); // Should default to empty string
      expect(customer.address, 'N/A');
      expect(customer.phoneNumber, 'N/A');
      expect(customer.sourceOfLead, 'N/A');
    });

    test('Job.fromFirestore should use snapshot.id', () {
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);
      
      final snapshot = TestDocumentSnapshot(
        id: 'job123',
        data: {
          'title': 'Test Job',
          'address': '123 Work St',
          'status': 'In Progress',
          'startDate': timestamp,
          'projectedEndDate': timestamp,
          // customer field is not included since it expects a Customer object
        },
      );

      final job = Job.fromFirestore(snapshot, null);

      expect(job.id, 'job123');
      expect(job.title, 'Test Job');
      expect(job.address, '123 Work St');
      expect(job.status, 'In Progress');
      expect(job.customer, isNull); // customer should be null when not provided
    });

    test('Job.fromFirestore should handle missing required fields', () {
      final snapshot = TestDocumentSnapshot(
        id: 'job789',
        data: {
          // Missing title and address
        },
      );

      final job = Job.fromFirestore(snapshot, null);

      expect(job.id, 'job789');
      expect(job.title, ''); // Should default to empty string
      expect(job.address, ''); // Should default to empty string
      expect(job.status, 'Pending'); // Should use default
    });

    test('Expense.fromDocumentSnapshot should use doc.id', () {
      final snapshot = TestDocumentSnapshot(
        id: 'expense123',
        data: {
          'name': 'Office Supplies',
          'cost': 150.50,
          'description': 'Printer paper and pens',
        },
      );

      final expense = Expense.fromDocumentSnapshot(snapshot);

      expect(expense.id, 'expense123');
      expect(expense.name, 'Office Supplies');
      expect(expense.cost, 150.50);
      expect(expense.description, 'Printer paper and pens');
    });

    test('All models should implement EditableModel interface', () {
      final customer = Customer(
        id: 'cust1',
        name: 'Test Customer',
        address: '123 Test St',
        phoneNumber: '555-1111',
        sourceOfLead: 'Web',
        potentialCustomers: [],
      );

      final job = Job(
        id: 'job1',
        title: 'Test Job',
        address: '456 Work Ave',
      );

      final expense = Expense(
        id: 'exp1',
        name: 'Equipment',
        cost: 1500.00,
        description: 'New laptop',
      );

      // Test model type names
      expect(customer.modelTypeName, 'Customer');
      expect(job.modelTypeName, 'Job');
      expect(expense.modelTypeName, 'Expense');

      // Test toFormData
      expect(customer.toFormData(), isA<Map<String, dynamic>>());
      expect(job.toFormData(), isA<Map<String, dynamic>>());
      expect(expense.toFormData(), isA<Map<String, dynamic>>());
    });
  });
}