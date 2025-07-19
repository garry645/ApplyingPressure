import 'package:applying_pressure/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../customers/customers_list_page.dart';
import '../expenses/expenses_list_page.dart';
import '../jobs/jobs_list_page.dart';
import '../services/service_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool loggedIn = true;
  late User? user;
  late final PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = ServiceProvider.getAuthService(context);
    user = authService.currentUser;
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const [
            JobsListPage(),
            CustomersListPage(),
            ExpensesListPage()
          ],
        ),
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
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
