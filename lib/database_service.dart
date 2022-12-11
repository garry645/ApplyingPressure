import 'package:cloud_firestore/cloud_firestore.dart';

import 'jobs/job.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addJob(Job jobData) async {
    await _db.collection("Jobs").add(jobData.toMap());
  }

  updateJob(Job jobData) async {
    await _db.collection("Jobs").doc(jobData.id).update(jobData.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    await _db.collection("Jobs").doc(documentId).delete();

  }

  Future<List<Job>> retrieveJobsByTitle(String title) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Jobs").where("title", isEqualTo: title).get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  Future<List<Job>> retrieveJobs() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Jobs").get();
    return snapshot.docs
        .map((docSnapshot) => Job.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}