import 'package:flutter/material.dart';

import '../customers/customers_page.dart';
import '../expenses/expenses_page.dart';
import '../jobs/jobs_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _pages = <Widget>[
    JobsListPage(),
    CustomersPage(),
    ExpensesPage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Jobs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.cases_outlined), label: "Customers"),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Expenses")
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
