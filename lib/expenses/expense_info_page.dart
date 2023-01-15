import 'dart:math';

import 'package:applying_pressure/expenses/expense.dart';
import 'package:flutter/material.dart';

class ExpenseInfoPage extends StatelessWidget {
  // In the constructor, require a Expense.
  const ExpenseInfoPage({super.key});
  static const routeName = '/expenseInfoPage';

  @override
  Widget build(BuildContext context) {
    final expense = ModalRoute.of(context)!.settings.arguments as Expense;
    // Use the Expense to create the UI.
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Expense: ${expense.name}\n\n"
            "Cost: ${expense.cost} \n\n"
            "Description: ${expense.description}\n\n")
      ),
    );
  }
}