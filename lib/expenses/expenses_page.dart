import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);
  final String title = "Expenses";
  static const routeName = '/expensesListPage';

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}


class _ExpensesPageState extends State<ExpensesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Shit")
              ],
            )
        )
    );
  }
}