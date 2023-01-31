import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String? id;
  final String name;
  final String address;
  final String sourceOfLead;
  final String phoneNumber;
  final List<Customer>? potentialCustomers;

  Customer(
      {this.id,
      required this.name,
      required this.address,
      required this.sourceOfLead,
      required this.phoneNumber,
      this.potentialCustomers});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'sourceOfLead': sourceOfLead,
      'potentialCustomers': potentialCustomers,
    };
  }

  Customer.fromDocumentSnapshot(DocumentSnapshot doc) 
    : id = doc.id,
      name = (doc.data() as dynamic)['name'] ?? "",
      address = (doc.data() as dynamic)["address"] ?? "",
      sourceOfLead = (doc.data() as dynamic)["sourceOfLead"] ?? "",
      phoneNumber = (doc.data() as dynamic)["phoneNumber"] ?? "",
      potentialCustomers = (doc.data() as dynamic)["potentialCustomers"] ?? [];

}
