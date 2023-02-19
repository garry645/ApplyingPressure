import 'package:applying_pressure/strings.dart';
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
  String currJobCollection = false ? testJobsCollection : jobsCollection;
  String currCustomerCollection = false ? testCustomersCollection : customersCollection;
  String currExpenseCollection = false ? testExpensesCollection : expensesCollection;

  addJob(Job jobData) async {
    await _db.collection(currJobCollection).withConverter(
      fromFirestore: Job.fromFirestore,
      toFirestore: (Job job, _) => job.toFirestore(),
    ).add(jobData);
  }

  updateJob(String id, Job newJobData) async {
    await _db.collection(currJobCollection).doc(id).update(newJobData.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    await _db.collection(currJobCollection).doc(documentId).delete();
  }

  Future<List<Job>> retrieveJobsByTitle(String title) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currJobCollection).where("title", isEqualTo: title).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<Job> retrieveJobById(String id) async {
    var snap = await _db.collection(currJobCollection).doc(id).withConverter(
      fromFirestore: Job.fromFirestore,
      toFirestore: (Job job, _) => job.toFirestore(),
    ).get();
    return snap.data() ?? Job(title: errorString, address: errorString);
  }

  Future<List<Job>> retrieveJobs() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currJobCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addCustomer(Customer customerData) async {
    await _db.collection(currCustomerCollection).add(customerData.toMap());
  }

  updateCustomer(Customer customerData) async {
    await _db.collection(currCustomerCollection).doc(customerData.id).update(customerData.toMap());
  }

  Future<void> deleteCustomer(String documentId) async {
    await _db.collection(currCustomerCollection).doc(documentId).delete();
  }

  Future<Customer> retrieveCustomerById(String id) async {
    var snap = await _db.collection(currCustomerCollection).doc(id).withConverter(
      fromFirestore: Customer.fromFirestore,
      toFirestore: (Customer customer, _) => customer.toFirestore(),
    ).get();
    return snap.data() ?? Customer(
        name: errorString,
        address: errorString,
        phoneNumber: errorString,
        sourceOfLead: errorString,
        potentialCustomers: List.empty());
  }
  Future<List<Customer>> retrieveCustomersByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currCustomerCollection).where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomersBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currCustomerCollection).where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Customer>> retrieveCustomers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currCustomerCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Customer.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  addExpense(Expense expenseData) async {
    await _db.collection(currExpenseCollection).add(expenseData.toMap());
  }

  updateExpense(Expense expenseData) async {
    await _db.collection(currExpenseCollection).doc(expenseData.id).update(expenseData.toMap());
  }

  Future<void> deleteExpense(String documentId) async {
    await _db.collection(currExpenseCollection).doc(documentId).delete();

  }

  Future<List<Expense>> retrieveExpensesByName(String name) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currExpenseCollection).where("name", isEqualTo: name).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpensesBySourceOfLead(String source) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currExpenseCollection).where("sourceOfLead", isEqualTo: source).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Expense>> retrieveExpenses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(currExpenseCollection).get();
    return snapshot.docs
        .map((docSnapshot) => Expense.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

}