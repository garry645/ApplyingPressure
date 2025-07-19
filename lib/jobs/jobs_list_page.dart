import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:applying_pressure/strings.dart';
import 'package:applying_pressure/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import 'job.dart';

class JobsListPage extends StatefulWidget {
  final String title = "Jobs";

  const JobsListPage({Key? key}) : super(key: key);

  static const routeName = '/jobsListPage';

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  DatabaseService service = DatabaseService();
  late Stream<QuerySnapshot<Map<String, dynamic>>> jobStream;

  @override
  void initState() {
    super.initState();

    jobStream = service.retrieveJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const APAppBar(title: 'Jobs'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: jobStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<DocumentSnapshot<Map<String, dynamic>>> jobs =
                  snapshot.data?.docs ?? [];

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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddJobPage()));
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

  Widget createDismisable(DocumentSnapshot<Map<String, dynamic>>? jobDoc) {
    if (jobDoc != null) {
      Job job = Job.fromJson(jobDoc.data());
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
          child: makeListTile(jobDoc));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget makeListTile(DocumentSnapshot<Map<String, dynamic>> jobDoc) {
    Job job = Job.fromJson(jobDoc.data());
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JobInfoPage(
                      jobDoc: jobDoc,
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
    return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
