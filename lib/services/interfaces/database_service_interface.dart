import 'package:cloud_firestore/cloud_firestore.dart';
import '../../customers/customer.dart';
import '../../expenses/expense.dart';
import '../../jobs/job.dart';

/// Abstract interface for database operations
abstract class DatabaseServiceInterface {
  // Collection names
  String get currJobCollection;
  String get currCustomerCollection;
  String get currExpenseCollection;

  // Job operations
  Future<void> addJob(Job jobData);
  Future<void> updateJob(String id, Job newJobData);
  Future<void> deleteJob(String documentId);
  Stream<List<Job>> retrieveJobs();
  Stream<List<Job>> getJobs();
  Stream<QuerySnapshot> fetchJobs();

  // Customer operations
  Future<void> addCustomer(Customer customerData);
  Future<void> updateCustomer(String id, Customer customerData);
  Future<void> deleteCustomer(String id);
  Stream<List<Customer>> retrieveCustomers();
  Stream<QuerySnapshot> fetchCustomers();
  Future<Customer?> getCustomerById(String id);
  Stream<Customer?> getCustomerStreamById(String id);

  // Expense operations
  Future<void> addExpense(Expense expenseData);
  Future<void> updateExpense(String id, Expense expenseData);
  Future<void> deleteExpense(String id);
  Stream<List<Expense>> retrieveExpenses();
}