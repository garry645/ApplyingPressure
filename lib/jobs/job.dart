import 'package:cloud_firestore/cloud_firestore.dart';

import '../customers/customer.dart';
import '../shared/editable_model.dart';

class Job extends EditableModel {
  final String? id;
  final String title;
  String status = "Pending";
  final String? address;
  final DateTime? startDate;
  final DateTime? projectedEndDate;
  DateTime? actualEndDate;
  Customer? customer;
  String? receiptImageUrl;

  Job(
      {this.id,
      required this.title,
      this.status = "Pending",
      required this.address,
      this.startDate,
      this.projectedEndDate,
      this.actualEndDate,
      this.customer,
      this.receiptImageUrl});

  factory Job.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Job(
        id: snapshot.id,
        title: data?['title'] ?? '',
        status: data?['status'] ?? "Pending",
        address: data?['address'] ?? '',
        startDate: data?['startDate'] != null ? (data!['startDate'] as Timestamp).toDate() : null,
        projectedEndDate: data?['projectedEndDate'] != null ? (data!['projectedEndDate'] as Timestamp).toDate() : null,
        actualEndDate: data?['actualEndDate'] != null 
            ? (data!['actualEndDate'] as Timestamp).toDate() 
            : null,
        customer: data?['customer'],
        receiptImageUrl: data?['receiptImageUrl']);
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
      if(receiptImageUrl != null) "receiptImageUrl": receiptImageUrl
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

  factory Job.fromJson(Map<String, dynamic>? json) {
    return Job(
      title: json?['title'] ?? '',
      address: json?['address'] ?? '',
      startDate: json?['startDate']?.toDate() ?? DateTime.now(),
      projectedEndDate: json?['projectedEndDate']?.toDate() ?? DateTime.now(),
      actualEndDate: json?['actualEndDate']?.toDate(),
    );
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
        actualEndDate = (doc.data() as dynamic)["actualEndDate"]?.toDate();

  @override
  Map<String, dynamic> toFormData() {
    return {
      'title': title,
      'address': address,
      'startDate': startDate,
      'projectedEndDate': projectedEndDate,
      'actualEndDate': actualEndDate,
      'status': status,
    };
  }

  @override
  String get modelTypeName => 'Job';

  Job copyWith({
    String? id,
    String? title,
    String? status,
    String? address,
    DateTime? startDate,
    DateTime? projectedEndDate,
    DateTime? actualEndDate,
    Customer? customer,
    String? receiptImageUrl,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      address: address ?? this.address,
      startDate: startDate ?? this.startDate,
      projectedEndDate: projectedEndDate ?? this.projectedEndDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      customer: customer ?? this.customer,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
    );
  }
}
