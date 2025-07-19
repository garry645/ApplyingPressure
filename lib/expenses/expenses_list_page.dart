import 'package:applying_pressure/expenses/expense.dart';
import 'package:applying_pressure/expenses/expense_info_page.dart';
import 'package:flutter/material.dart';

import '../services/service_provider.dart';
import '../services/interfaces/database_service_interface.dart';
import '../routes.dart';
import 'add_expense_page.dart';

class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({Key? key}) : super(key: key);
  final String title = "ExpensesList";
  static const routeName = '/expensesListPage';

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  late DatabaseServiceInterface service;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    service = ServiceProvider.getDatabaseService(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Stream will automatically update when data changes
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<Expense>>(
            stream: service.retrieveExpenses(),
            builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final expenses = snapshot.data ?? [];
              
              if (expenses.isEmpty) {
                return createEmptyState();
              }
              
              return ListView.separated(
                itemCount: expenses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return createDismisable(expenses[index]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, Routes.addExpense);
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget createEmptyState() {
    return Center(
      child: ListView(
        children: const <Widget>[
          Align(
              alignment: AlignmentDirectional.center,
              child: Text('No data available')),
        ],
      ),
    );
  }

  Widget createDismisable(Expense expense) {
    return Dismissible(
        onDismissed: ((direction) async {
          await service.deleteExpense(
              expense.id.toString());
        }),
        background: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.only(right: 28.0),
          alignment: AlignmentDirectional.centerEnd,
          child: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        direction: DismissDirection.endToStart,
        resizeDuration: const Duration(milliseconds: 200),
        key: UniqueKey(),
        child: makeListTile(expense)
    );
  }

  Widget makeListTile(Expense expenseIn) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpenseInfoPage(expense: expenseIn)));
        //Navigator.pushNamed(context, ExpenseInfoPage.routeName, arguments: expense);
      },
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5)),
      title: Text(expenseIn.name ?? ""),
      subtitle:
      Text("${expenseIn.description ?? "Empty"} \n"),
      trailing: const Icon(Icons.arrow_right_sharp),
    );
  }
}
