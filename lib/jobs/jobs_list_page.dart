import 'package:applying_pressure/jobs/add_job_page.dart';
import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import 'job.dart';

class JobsListPage extends StatefulWidget {
  const JobsListPage({Key? key}) : super(key: key);
  final String title = "Jobs";

  static const routeName = '/jobsListPage';

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  DatabaseService service = DatabaseService();
  Future<List<Job>>? jobList;
  List<Job>? retrievedJobList;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    jobList = service.retrieveJobs();
    retrievedJobList = await service.retrieveJobsByTitle("NewJob1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _initRetrieval,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: jobList,
            builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedJobList!.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return createDismissable(retrievedJobList?[index]);
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  retrievedJobList!.isEmpty) {
                return createEmptyState();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, AddJobPage.routeName);
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

  Widget createDismissable(Job? job) {
    return Dismissible(
        onDismissed: ((direction) async {
          await service.deleteJob(
              job?.id.toString() ?? "");
        }),
        background: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5)),
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
        child: makeListTile(job)
    );
  }

  Widget makeListTile(Job? job) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, JobInfoPage.routeName, arguments: job);
      },
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5)),
      title: Text(job?.title ?? ""),
      subtitle:
      Text("${job?.startDate ?? "stdte"} "
          "${job?.title ?? "sffed"}"),
      trailing: const Icon(Icons.arrow_right_sharp),
    );
  }
}

//Job("Title", "StartDate", "ProjectedEndDate","ActualEndDate")
/*
StreamBuilder<QuerySnapshot>(
stream: jobsCollection.snapshots(),
builder: (context, snapshot) {
if (!snapshot.hasData) return const Text('Loading...');
return ListView.separated(
padding: const EdgeInsets.symmetric(
horizontal: 10.0, vertical: 10.0),
itemCount: snapshot.data?.docs.length ?? 0,
itemBuilder: (context, index) =>
makeListTile(snapshot.data?.docs[index]),
separatorBuilder: (BuildContext context, int index) =>
const Divider(),
);
}));*/
