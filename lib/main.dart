import 'package:applying_pressure/customers/customers_page.dart';
import 'package:applying_pressure/expenses/expenses_page.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home/home_page.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ApplyingPressureApp());
}

class ApplyingPressureApp extends StatelessWidget {
  const ApplyingPressureApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applying Pressure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: globals.homePage,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        JobsListPage.routeName: (context) => const JobsListPage(),
        AddJobPage.routeName: (context) => const AddJobPage(),
        JobInfoPage.routeName: (context) => const JobInfoPage(),
        CustomersPage.routeName: (context) => const CustomersPage(),
        ExpensesPage.routeName: (context) => const ExpensesPage()
      },
    );
  }
}

