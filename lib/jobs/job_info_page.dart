import 'package:applying_pressure/jobs/job.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';

class JobInfoPage extends StatefulWidget {
  // In the constructor, require a Job.
  const JobInfoPage({super.key});

  static const routeName = '/jobInfoPage';

  @override
  State<JobInfoPage> createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  DatabaseService service = DatabaseService();
  String jobId = "";

  Future<Job> _initRetrieval() async {
    jobId = ModalRoute.of(context)!.settings.arguments as String;
    return service.retrieveJobById(jobId);
  }

  @override
  Widget build(BuildContext context) {
    //final job = //ModalRoute.of(context)!.settings.arguments as Job;
    // Use the Job to create the UI.
    return FutureBuilder<Job>(future: _initRetrieval(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _jobInfoPage(Job(title: "Error", address: "Error"));
          } else if (snapshot.hasData) {
            Job job = snapshot.data!;
            return _jobInfoPage(job);
          } else {
            return _jobInfoPage(Job(title: "Loading", address: "Loading"));
          }
        });
  }

  Widget _jobInfoPage(Job job) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[100],
      body: Center(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(color: Colors.blue[600]),
                child: Wrap(children: [
                  Column(
                    children: [
                      Text('${job.title}\n\n', style: headerText()),
                      Text('Status: ', style: subTitleText()),
                      Text('${job.status}\n\n', style: headerText()),
                      Column(children: [
                        Text('Start Date: ', style: subTitleText()),
                        Text(getJobStartDateString(job), style: subTitleText()),
                      ]),
                      const SizedBox(width: 8),
                      Column(children: [
                        Text('Projected End Date: ', style: subTitleText()),
                        Text(getJobEndDateString(job), style: subTitleText()),
                      ])
                    ],
                  )
                ])),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                job.status = "finished";
                service.updateJob(jobId, job);
                setState(() {});
              },
              child: const Text('Finish Job'),
            )
          ])),
    );
  }

  TextStyle headerText() {
    return const TextStyle(
        fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle subTitleText() {
    return const TextStyle(fontSize: 13, color: Colors.white);
  }

  String getJobStartDateString(Job? job) {
    return '${job?.startDate?.month}/${job?.startDate?.day}/${job?.startDate?.year} '
        '${job?.startDate?.hour}:${job?.startDate?.minute}\n\n';
  }

  String getJobEndDateString(Job? job) {
    return '${job?.projectedEndDate?.month}/${job?.projectedEndDate?.day}/${job?.projectedEndDate?.year} '
        '${job?.projectedEndDate?.hour}:${job?.projectedEndDate?.minute}\n\n';
  }
}
