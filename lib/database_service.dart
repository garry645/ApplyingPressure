import 'package:cloud_firestore/cloud_firestore.dart';

import 'customers/customer.dart';
import 'expenses/expense.dart';
import 'jobs/job.dart';

const String testJobsCollection = "TestJobs";
const String testCustomersCollection = "TestCustomers";
const String testExpensesCollection = "TestExpenses";

const String jobsCollection = "Jobs";
const String customersCollection = "Customers";
const String expensesCollection = "Expenses";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addJob(Job jobData) async {
    await _db.collection(jobsCollection).add(jobData.toMap());
  }

  updateJob(Job jobData) async {
    await _db.collection(jobsCollection).doc(jobData.id).update(jobData.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    await _db.collection(jobsCollection).doc(documentId).delete();

  }

  Future<List<Job>> retrieveJobsByTitle(String title) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(jobsCollection).where("title", isEqualTo: title).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Job>> retrieveJobs() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(jobsCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addCustomer(Customer customerData) async {
    await _db.collection(customersCollection).add(customerData.toMap());
  }

  updateCustomer(Customer customerData) async {
    await _db.collection(customersCollection).doc(customerData.id).update(customerData.toMap());
  }

  Future<void> deleteCustomer(String documentId) async {
    await _db.collection(customersCollection).doc(documentId).delete();
  }

  Future<List<Customer>> retrieveCustomersByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(customersCollection).where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomersBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(customersCollection).where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(customersCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addExpense(Expense expenseData) async {
    await _db.collection(expensesCollection).add(expenseData.toMap());
  }

  updateExpense(Expense expenseData) async {
    await _db.collection(expensesCollection).doc(expenseData.id).update(expenseData.toMap());
  }

  Future<void> deleteExpense(String documentId) async {
    await _db.collection(expensesCollection).doc(documentId).delete();

  }

  Future<List<Expense>> retrieveExpensesByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(expensesCollection).where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpensesBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(expensesCollection).where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpenses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(expensesCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

}