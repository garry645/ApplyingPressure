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
        child: Text('${job.title}\n\n'
            'Start Date: '
            '${job.startDate?.month}/${job.startDate?.day}/${job.startDate?.year} '
            '${job.startDate?.hour}:${job.startDate?.minute}\n\n'
            'Projected End Date: '
            '${job.projectedEndDate?.month}/${job.projectedEndDate?.day}/${job.projectedEndDate?.year} '
            '${job.projectedEndDate?.hour}:${job.projectedEndDate?.minute}\n\n'),
      ),
    );
  }
}