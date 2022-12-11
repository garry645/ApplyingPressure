import 'package:cloud_firestore/cloud_firestore.dart';

import '../customers/customer.dart';

class Job {
  final String? id;
  final String title;
  final String? startDate;
  final String? projectedEndDate;
  final String? actualEndDate;
  final Customer? customer = null;

  const Job(
      {this.id,
      required this.title,
      this.startDate,
      this.projectedEndDate,
      this.actualEndDate});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startDate': startDate,
      'projectedEndDate': projectedEndDate,
      'actualEndDate': actualEndDate,
    };
  }

  Job.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = doc['title'] ?? "loading",
        startDate = doc["startDate"],
        projectedEndDate = doc["projectedEndDate"],
        actualEndDate = doc["actualEndDate"];
}