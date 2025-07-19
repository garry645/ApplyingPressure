import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../interfaces/database_service_interface.dart';
import '../../customers/customer.dart';
import '../../expenses/expense.dart';
import '../../jobs/job.dart';

const String testJobsCollection = "TestJobs";
const String testCustomersCollection = "TestCustomers";
const String testExpensesCollection = "TestExpenses";

const String jobsCollection = "Jobs";
const String customersCollection = "Customers";
const String expensesCollection = "Expenses";

/// Firebase implementation of DatabaseServiceInterface
class FirebaseDatabaseService implements DatabaseServiceInterface {
  final FirebaseFirestore _db;
  
  @override
  late final String currJobCollection;
  
  @override
  late final String currCustomerCollection;
  
  @override
  late final String currExpenseCollection;
  
  FirebaseDatabaseService({FirebaseFirestore? firestore}) 
      : _db = firestore ?? FirebaseFirestore.instance {
    bool useTestCollections = false;
    
    // For web builds, always use production collections
    if (kIsWeb) {
      print('[FirebaseDatabaseService] Web build detected, using production collections');
      useTestCollections = false;
    } else {
      // For mobile/desktop, check dotenv
      try {
        final String? testCollectionsSetting = dotenv.env['USE_TEST_COLLECTIONS'];
        useTestCollections = testCollectionsSetting == 'true';
        print('[FirebaseDatabaseService] USE_TEST_COLLECTIONS: $testCollectionsSetting');
      } catch (e) {
        print('[FirebaseDatabaseService] Error reading dotenv, defaulting to production');
        useTestCollections = false;
      }
    }
    
    print('[FirebaseDatabaseService] useTestCollections: $useTestCollections');
    currJobCollection = useTestCollections ? testJobsCollection : jobsCollection;
    currCustomerCollection = useTestCollections ? testCustomersCollection : customersCollection;
    currExpenseCollection = useTestCollections ? testExpensesCollection : expensesCollection;
    print('[FirebaseDatabaseService] Using collections: Jobs=$currJobCollection, Customers=$currCustomerCollection, Expenses=$currExpenseCollection');
  }

  // Job operations
  @override
  Future<Job> addJob(Job jobData) async {
    final docRef = await _db.collection(currJobCollection).withConverter(
      fromFirestore: Job.fromFirestore,
      toFirestore: (Job job, _) => job.toFirestore(),
    ).add(jobData);
    
    // Return the job with the generated ID
    return jobData.copyWith(id: docRef.id);
  }

  @override
  Future<void> updateJob(String id, Job newJobData) async {
    await _db.collection(currJobCollection).doc(id).update(newJobData.toMap());
  }

  @override
  Future<void> deleteJob(String documentId) async {
    await _db.collection(currJobCollection).doc(documentId).delete();
  }

  @override
  Stream<List<Job>> retrieveJobs() {
    return _db.collection(currJobCollection)
        .orderBy("startDate", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Job.fromFirestore(doc, null);
      }).toList();
    });
  }

  @override
  Stream<List<Job>> getJobs() => retrieveJobs();

  @override
  Stream<QuerySnapshot> fetchJobs() {
    return _db.collection(currJobCollection).snapshots();
  }

  // Customer operations
  @override
  Future<void> addCustomer(Customer customerData) async {
    await _db.collection(currCustomerCollection).add(customerData.toMap());
  }

  @override
  Future<void> updateCustomer(String id, Customer customerData) async {
    await _db.collection(currCustomerCollection).doc(id).update(customerData.toMap());
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await _db.collection(currCustomerCollection).doc(id).delete();
  }

  @override
  Stream<List<Customer>> retrieveCustomers() {
    return _db.collection(currCustomerCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Customer.fromFirestore(doc, null);
      }).toList();
    });
  }

  @override
  Stream<QuerySnapshot> fetchCustomers() {
    return _db.collection(currCustomerCollection).snapshots();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection(currCustomerCollection).doc(id).get();
      if (doc.exists) {
        return Customer.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      print('Error getting customer: $e');
      return null;
    }
  }

  @override
  Stream<Customer?> getCustomerStreamById(String id) {
    return _db.collection(currCustomerCollection).doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Customer.fromFirestore(doc, null);
      }
      return null;
    });
  }

  // Expense operations
  @override
  Future<void> addExpense(Expense expenseData) async {
    await _db.collection(currExpenseCollection).add(expenseData.toMap());
  }

  @override
  Future<void> updateExpense(String id, Expense expenseData) async {
    await _db.collection(currExpenseCollection).doc(id).update(expenseData.toMap());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _db.collection(currExpenseCollection).doc(id).delete();
  }

  @override
  Stream<List<Expense>> retrieveExpenses() {
    return _db.collection(currExpenseCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromDocumentSnapshot(doc);
      }).toList();
    });
  }
}