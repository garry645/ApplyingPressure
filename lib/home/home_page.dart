import 'package:applying_pressure/customers/customers_page.dart';
import 'package:applying_pressure/expenses/expenses_page.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _pages = <Widget>[
    JobsListPage(title: "Jobs"),
    CustomersPage(title: "Customers"),
    ExpensesPage(title: "Expenses")
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
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
