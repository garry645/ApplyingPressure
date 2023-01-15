import 'package:cloud_firestore/cloud_firestore.dart';

import '../customers/customer.dart';

class Job {
  final String? id;
  final String title;
  final bool finished = false;
  final String address;
  final DateTime? startDate;
  final DateTime? projectedEndDate;
  DateTime? actualEndDate;
  final Customer? customer = null;

  Job(
      {this.id,
      required this.title,
      required this.address,
      this.startDate,
      this.projectedEndDate});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startDate': startDate,
      'address': address,
      'projectedEndDate': projectedEndDate,
      'actualEndDate': actualEndDate,
    };
  }

  Job.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = doc['title'] ?? "loading",
        address = doc['address'],
        startDate = doc["startDate"].toDate(),
        projectedEndDate = doc["projectedEndDate"].toDate(),
        actualEndDate = doc["actualEndDate"]?.toDate();
}