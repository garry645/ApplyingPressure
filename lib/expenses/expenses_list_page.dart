import 'package:applying_pressure/expenses/expense.dart';
import 'package:applying_pressure/expenses/expense_info_page.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import 'add_expense_page.dart';

class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({Key? key}) : super(key: key);
  final String title = "ExpensesList";
  static const routeName = '/expensesListPage';

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  DatabaseService service = DatabaseService();
  Future<List<Expense>>? expenseList;
  List<Expense> retrievedExpenseList = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    expenseList = service.retrieveExpenses();
    retrievedExpenseList = await service.retrieveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _initRetrieval,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: expenseList,
            builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedExpenseList.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      Expense expense = retrievedExpenseList[index];
                      return createDismisable(expense);
                    });
              } else if (snapshot.connectionState == ConnectionState.done
                  && retrievedExpenseList.isEmpty) {
                return createEmptyState();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, AddExpensePage.routeName);
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
              expense.id.toString() ?? "");
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
