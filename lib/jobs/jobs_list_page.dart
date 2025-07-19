import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:applying_pressure/strings.dart';
import 'package:applying_pressure/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../services/service_provider.dart';
import '../services/interfaces/database_service_interface.dart';
import '../routes.dart';
import 'job.dart';

class JobsListPage extends StatefulWidget {
  final String title = "Jobs";

  const JobsListPage({Key? key}) : super(key: key);

  static const routeName = '/jobsListPage';

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  late DatabaseServiceInterface service;
  late Stream<List<Job>> jobStream;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    service = ServiceProvider.getDatabaseService(context);
    jobStream = service.retrieveJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const APAppBar(title: 'Jobs'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<Job>>(
            stream: jobStream,
            builder: (context, snapshot) {
              // Show loading only if we have no data at all
              if (snapshot.connectionState == ConnectionState.waiting && 
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Show error if there's one
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            jobStream = service.retrieveJobs();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              List<Job> jobs = snapshot.data ?? [];
                  
              if (jobs.isEmpty) {
                return const Center(
                  child: Text('No jobs yet. Tap + to add your first job!'),
                );
              }

              return ListView.separated(
                  itemCount: jobs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return createDismisable(jobs[index]);
                  });
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, Routes.addJob);
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget createEmptyState() {
    return Center(
      child: ListView(
        children: const <Widget>[
          Align(
              alignment: AlignmentDirectional.center,
              child: Text('No data available')),
        ],
      ),
    );
  }

  Widget createDismisable(Job job) {
    return Dismissible(
        onDismissed: ((direction) async {
          await service.deleteJob(job.id.toString());
        }),
          background: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.only(right: 28.0),
            alignment: AlignmentDirectional.centerEnd,
            child: const Text(
              "DELETE",
              style: TextStyle(color: Colors.white),
            ),
        ),
        direction: DismissDirection.endToStart,
        resizeDuration: const Duration(milliseconds: 200),
        key: UniqueKey(),
        child: makeListTile(job));
  }

  Widget makeListTile(Job job) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JobInfoPage(
                      job: job,
                    )));
        //Navigator.pushNamed(context, JobInfoPage.routeName, arguments: job.id);
      },
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5)),
      title: Text(job.title),
      subtitle: Text(_formatDate(job.startDate) + "\n" +
          _formatDate(job.projectedEndDate)),
      trailing: const Icon(Icons.arrow_right_sharp),
    );
  }
  
  String _formatDate(DateTime? date) {
    if (date == null) return naString;
    return '${date.month}/${date.day}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
