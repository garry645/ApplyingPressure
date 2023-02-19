import 'package:cloud_firestore/cloud_firestore.dart';

import '../customers/customer.dart';
class Job {
  final String? id;
  final String title;
  String status = "Pending";
  final String? address;
  final DateTime? startDate;
  final DateTime? projectedEndDate;
  DateTime? actualEndDate;
  Customer? customer;

  Job(
      {this.id,
      required this.title,
      this.status = "Pending",
      required this.address,
      this.startDate,
      this.projectedEndDate,
      this.actualEndDate,
      this.customer});

  factory Job.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Job(
        id: data?['id'],
        title: data?['title'],
        status: data?['status'] ?? "Pending",
        address: data?['address'],
        startDate: (data?['startDate'] as Timestamp).toDate(),
        projectedEndDate: (data?['projectedEndDate'] as Timestamp).toDate(),
        actualEndDate: (data?['projectedEndDate'] as Timestamp).toDate(),
        customer: data?['customer']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "title": title,
      "status": status,
      "address": address,
      if (startDate != null) "startDate": startDate,
      if (projectedEndDate != null) "projectedEndDate": projectedEndDate,
      if (actualEndDate != null) "actualEndDate": actualEndDate,
      if (customer != null) "customer": customer,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startDate': startDate,
      'status': status,
      'address': address,
      'projectedEndDate': projectedEndDate,
      'actualEndDate': actualEndDate,
    };
  }

  Job.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = (doc.data() as dynamic)['title'] ?? "N/A",
        address = (doc.data() as dynamic)['address'] ?? "N/A",
        startDate =
            (doc.data() as dynamic)["startDate"].toDate() ?? DateTime.now(),
        projectedEndDate =
            (doc.data() as dynamic)["projectedEndDate"].toDate() ??
                DateTime.now(),
        actualEndDate = (doc.data() as dynamic)["actualEndDate"]?.toDate() ??
            DateTime.now();
}
