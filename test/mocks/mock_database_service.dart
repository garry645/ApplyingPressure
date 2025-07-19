import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applying_pressure/services/interfaces/database_service_interface.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/expenses/expense.dart';

class MockDatabaseService implements DatabaseServiceInterface {
  final List<Job> _jobs = [];
  final List<Customer> _customers = [];
  final List<Expense> _expenses = [];
  
  final _jobsController = StreamController<List<Job>>.broadcast();
  final _customersController = StreamController<List<Customer>>.broadcast();
  final _expensesController = StreamController<List<Expense>>.broadcast();
  
  @override
  String get currJobCollection => 'MockJobs';
  
  @override
  String get currCustomerCollection => 'MockCustomers';
  
  @override
  String get currExpenseCollection => 'MockExpenses';
  
  // Job operations
  @override
  Future<void> addJob(Job jobData) async {
    final newJob = Job(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: jobData.title,
      address: jobData.address,
      startDate: jobData.startDate,
      projectedEndDate: jobData.projectedEndDate,
      actualEndDate: jobData.actualEndDate,
      customer: jobData.customer,
      receiptImageUrl: jobData.receiptImageUrl,
    );
    _jobs.add(newJob);
    _jobsController.add(List.from(_jobs));
  }
  
  @override
  Future<void> updateJob(String id, Job newJobData) async {
    final index = _jobs.indexWhere((job) => job.id == id);
    if (index != -1) {
      _jobs[index] = Job(
        id: id,
        title: newJobData.title,
        address: newJobData.address,
        startDate: newJobData.startDate,
        projectedEndDate: newJobData.projectedEndDate,
        actualEndDate: newJobData.actualEndDate,
        customer: newJobData.customer,
        receiptImageUrl: newJobData.receiptImageUrl,
      );
      _jobsController.add(List.from(_jobs));
    }
  }
  
  @override
  Future<void> deleteJob(String documentId) async {
    _jobs.removeWhere((job) => job.id == documentId);
    _jobsController.add(List.from(_jobs));
  }
  
  @override
  Stream<List<Job>> retrieveJobs() {
    // Return current jobs immediately
    if (_jobs.isNotEmpty) {
      _jobsController.add(List.from(_jobs));
    }
    return _jobsController.stream;
  }
  
  @override
  Stream<List<Job>> getJobs() => retrieveJobs();
  
  @override
  Stream<QuerySnapshot> fetchJobs() {
    throw UnimplementedError('Use retrieveJobs() instead');
  }
  
  // Customer operations
  @override
  Future<void> addCustomer(Customer customerData) async {
    final newCustomer = Customer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: customerData.name,
      address: customerData.address,
      sourceOfLead: customerData.sourceOfLead,
      phoneNumber: customerData.phoneNumber,
      potentialCustomers: customerData.potentialCustomers,
    );
    _customers.add(newCustomer);
    _customersController.add(List.from(_customers));
  }
  
  @override
  Future<void> updateCustomer(String id, Customer customerData) async {
    final index = _customers.indexWhere((customer) => customer.id == id);
    if (index != -1) {
      _customers[index] = Customer(
        id: id,
        name: customerData.name,
        address: customerData.address,
        sourceOfLead: customerData.sourceOfLead,
        phoneNumber: customerData.phoneNumber,
        potentialCustomers: customerData.potentialCustomers,
      );
      _customersController.add(List.from(_customers));
    }
  }
  
  @override
  Future<void> deleteCustomer(String id) async {
    _customers.removeWhere((customer) => customer.id == id);
    _customersController.add(List.from(_customers));
  }
  
  @override
  Stream<List<Customer>> retrieveCustomers() {
    if (_customers.isNotEmpty) {
      _customersController.add(List.from(_customers));
    }
    return _customersController.stream;
  }
  
  @override
  Stream<QuerySnapshot> fetchCustomers() {
    throw UnimplementedError('Use retrieveCustomers() instead');
  }
  
  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Stream<Customer?> getCustomerStreamById(String id) {
    final controller = StreamController<Customer?>();
    final customer = _customers.firstWhere(
      (c) => c.id == id,
      orElse: () => null as Customer,
    );
    controller.add(customer);
    return controller.stream;
  }
  
  // Expense operations
  @override
  Future<void> addExpense(Expense expenseData) async {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: expenseData.name,
      cost: expenseData.cost,
      description: expenseData.description,
    );
    _expenses.add(newExpense);
    _expensesController.add(List.from(_expenses));
  }
  
  @override
  Future<void> updateExpense(String id, Expense expenseData) async {
    final index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      _expenses[index] = Expense(
        id: id,
        name: expenseData.name,
        cost: expenseData.cost,
        description: expenseData.description,
      );
      _expensesController.add(List.from(_expenses));
    }
  }
  
  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
    _expensesController.add(List.from(_expenses));
  }
  
  @override
  Stream<List<Expense>> retrieveExpenses() {
    if (_expenses.isNotEmpty) {
      _expensesController.add(List.from(_expenses));
    }
    return _expensesController.stream;
  }
  
  // Helper methods for testing
  void addTestJob(Job job) {
    _jobs.add(job);
    _jobsController.add(List.from(_jobs));
  }
  
  void addTestCustomer(Customer customer) {
    _customers.add(customer);
    _customersController.add(List.from(_customers));
  }
  
  void addTestExpense(Expense expense) {
    _expenses.add(expense);
    _expensesController.add(List.from(_expenses));
  }
  
  void clearAll() {
    _jobs.clear();
    _customers.clear();
    _expenses.clear();
    _jobsController.add([]);
    _customersController.add([]);
    _expensesController.add([]);
  }
  
  void dispose() {
    _jobsController.close();
    _customersController.close();
    _expensesController.close();
  }
}