import 'dart:async';
import 'package:applying_pressure/database_service.dart';
import 'package:applying_pressure/login/auth.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/expenses/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

// Mock DatabaseService
class MockDatabaseService extends Mock implements DatabaseService {
  @override
  Stream<List<Job>> retrieveJobs() {
    return Stream.value([]);
  }

  @override
  Stream<List<Job>> getJobs() {
    return Stream.value([]);
  }

  @override
  Stream<List<Customer>> retrieveCustomers() {
    return Stream.value([]);
  }

  @override
  Stream<List<Expense>> retrieveExpenses() {
    return Stream.value([]);
  }

  @override
  String get currJobCollection => 'TestJobs';

  @override
  String get currCustomerCollection => 'TestCustomers';

  @override
  String get currExpenseCollection => 'TestExpenses';
}

// Mock Auth
class MockAuth extends Mock implements Auth {
  final _authStateController = StreamController<User?>.broadcast();

  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> signOut() async {}

  void dispose() {
    _authStateController.close();
  }
}