import 'package:cloud_firestore/cloud_firestore.dart';

import 'customers/customer.dart';
import 'expenses/expense.dart';
import 'jobs/job.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addJob(Job jobData) async {
    await _db.collection("Jobs").add(jobData.toMap());
  }

  updateJob(Job jobData) async {
    await _db.collection("Jobs").doc(jobData.id).update(jobData.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    await _db.collection("Jobs").doc(documentId).delete();

  }

  Future<List<Job>> retrieveJobsByTitle(String title) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Jobs").where("title", isEqualTo: title).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Job>> retrieveJobs() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Jobs").get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addCustomer(Customer customerData) async {
    await _db.collection("Customers").add(customerData.toMap());
  }

  updateCustomer(Customer customerData) async {
    await _db.collection("Customers").doc(customerData.id).update(customerData.toMap());
  }

  Future<void> deleteCustomer(String documentId) async {
    await _db.collection("Customers").doc(documentId).delete();
  }

  Future<List<Customer>> retrieveCustomersByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Customers").where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomersBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Customers").where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Customers").get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addExpense(Expense expenseData) async {
    await _db.collection("Expenses").add(expenseData.toMap());
  }

  updateExpense(Expense expenseData) async {
    await _db.collection("Expenses").doc(expenseData.id).update(expenseData.toMap());
  }

  Future<void> deleteExpense(String documentId) async {
    await _db.collection("Expenses").doc(documentId).delete();

  }

  Future<List<Expense>> retrieveExpensesByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Expenses").where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpensesBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Expenses").where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpenses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Expenses").get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

}