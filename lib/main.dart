import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home/home_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const JobsListPage(title: 'Dashboard'),
        '/add': (context) => const AddJobPage(),
        '/edit' : (context) => const JobInfoPage()
      },
    );
  }
}

