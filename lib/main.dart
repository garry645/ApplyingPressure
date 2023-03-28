import 'package:applying_pressure/camera/display_picture_screen.dart';
import 'package:applying_pressure/camera/take_picture_screen.dart';
import 'package:applying_pressure/customers/customer_info_page.dart';
import 'package:applying_pressure/customers/customers_list_page.dart';
import 'package:applying_pressure/expenses/add_expense_page.dart';
import 'package:applying_pressure/expenses/expense_info_page.dart';
import 'package:applying_pressure/expenses/expenses_list_page.dart';
import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:applying_pressure/login/login_page.dart';
import 'package:applying_pressure/widgets/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'customers/add_customer_page.dart';
import 'home/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: WidgetTree.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        WidgetTree.routeName: (context) => const WidgetTree(),
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        JobsListPage.routeName: (context) => const JobsListPage(),
        AddJobPage.routeName: (context) => const AddJobPage(),
        JobInfoPage.routeName: (context) => const JobInfoPage(),
        CustomersListPage.routeName: (context) => const CustomersListPage(),
        AddCustomerPage.routeName: (context) => const AddCustomerPage(),
        CustomerInfoPage.routeName: (context) => const CustomerInfoPage(),
        ExpensesListPage.routeName: (context) => const ExpensesListPage(),
        AddExpensePage.routeName: (context) => const AddExpensePage(),
        ExpenseInfoPage.routeName: (context) => const ExpenseInfoPage(),
        TakePictureScreen.routeName: (context) => const TakePictureScreen()

      },
    );
  }
}

