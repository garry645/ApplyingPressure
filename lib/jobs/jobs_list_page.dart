import 'package:applying_pressure/jobs/job_info_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import 'job.dart';

class JobsListPage extends StatefulWidget {
  const JobsListPage({Key? key, required this.title}) : super(key: key);
  final String title;

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
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: ((direction) async {
                          await service.deleteJob(
                              retrievedJobList![index].id.toString());
                          //_dismiss();
                        }),
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16.0)),
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
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 83, 80, 80),
                              borderRadius: BorderRadius.circular(16.0)),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/edit",
                                  arguments: retrievedJobList![index]);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text(retrievedJobList![index].title),
                            subtitle:
                                Text("${retrievedJobList![index].startDate}, "
                                    "${retrievedJobList![index].startDate}"),
                            trailing: const Icon(Icons.arrow_right_sharp),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  retrievedJobList!.isEmpty) {
                return Center(
                  child: ListView(
                    children: const <Widget>[
                      Align(
                          alignment: AlignmentDirectional.center,
                          child: Text('No data available')),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, '/add');
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget makeListTile(QueryDocumentSnapshot? document) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          document?['startDate'] ?? "loading",
        ),
      ),
      title: Text(
        document?['title'] ?? "loading",
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Colors.grey.shade900, size: 30.0),
      /*onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobInfoPage(
                  job: Job.fromDocumentSnapshot(document)),
            ),
          );
        }*/
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
