import 'package:applying_pressure/jobs/job.dart';
import 'package:flutter/material.dart';

class JobInfoPage extends StatelessWidget {
  // In the constructor, require a Job.
  const JobInfoPage({super.key});
  static const routeName = '/jobInfoPage';

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context)!.settings.arguments as Job;
    // Use the Job to create the UI.
    return Scaffold(
      appBar: AppBar(
        //title: Text(job.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(job.title),
      ),
    );
  }
}