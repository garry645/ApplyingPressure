import 'dart:math';

import 'package:applying_pressure/expenses/expense.dart';
import 'package:flutter/material.dart';
import '../services/service_provider.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';

class ExpenseInfoPage extends StatefulWidget {
  final Expense expense;

  // In the constructor, require a Expense.
  const ExpenseInfoPage({super.key, required this.expense});
  static const routeName = '/expenseInfoPage';

  @override
  State<ExpenseInfoPage> createState() => _ExpenseInfoPageState();
}

class _ExpenseInfoPageState extends State<ExpenseInfoPage> {

  @override
  Widget build(BuildContext context) {
    final databaseService = ServiceProvider.getDatabaseService(context);
    
    return StreamBuilder<List<Expense>>(
      stream: databaseService.retrieveExpenses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        // Find the expense with matching ID
        final expense = snapshot.data!.firstWhere(
          (e) => e.id == widget.expense.id,
          orElse: () => widget.expense,
        );
        
        return _buildExpenseInfo(expense);
      },
    );
  }
  
  Widget _buildExpenseInfo(Expense expense) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToEditPage(expense);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Expense: ${expense.name}\n\n"
            "Cost: ${expense.cost} \n\n"
            "Description: ${expense.description}\n\n")
      ),
    );
  }

  void _navigateToEditPage(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFormPage<Expense>(
          existingModel: expense,
          fieldConfigs: [
            const FormFieldConfig(
              name: 'name',
              label: 'Name',
              hintText: 'Enter Expense Name',
              isRequired: true,
            ),
            FormFieldConfig(
              name: 'cost',
              label: 'Cost',
              hintText: 'Enter Expense Cost',
              keyboardType: TextInputType.number,
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Expense Cost';
                }
                final cost = double.tryParse(value);
                if (cost == null || cost < 0) {
                  return 'Please enter a valid cost';
                }
                return null;
              },
            ),
            const FormFieldConfig(
              name: 'description',
              label: 'Description',
              hintText: 'Enter Expense Description',
              isRequired: true,
              maxLines: 3,
            ),
          ],
          modelBuilder: (formData) {
            return Expense(
              id: expense.id,
              name: formData['name']?.toString() ?? expense.name,
              cost: double.tryParse(formData['cost']?.toString() ?? '') ?? expense.cost,
              description: formData['description']?.toString() ?? expense.description,
            );
          },
          onSave: (updatedExpense) async {
            final service = ServiceProvider.getDatabaseService(context);
            await service.updateExpense(expense.id!, updatedExpense);
          },
        ),
      ),
    );
  }
}