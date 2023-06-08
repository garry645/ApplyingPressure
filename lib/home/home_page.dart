import 'package:applying_pressure/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../customers/customers_list_page.dart';
import '../expenses/expenses_list_page.dart';
import '../jobs/jobs_list_page.dart';
import '../login/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _pages = <Widget>[
    JobsListPage(),
    CustomersListPage(),
    ExpensesListPage()
  ];

  int _selectedIndex = 0;
  bool loggedIn = true;
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return Scaffold(
        body: Center(child: _pages.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Jobs"),
            BottomNavigationBarItem(
                icon: Icon(Icons.cases_outlined), label: "Customers"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add), label: "Expenses")
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      );
    } else {
      return const Text("");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      if (!loggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      _selectedIndex = index;
    });
  }
}
