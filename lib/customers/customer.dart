import 'package:cloud_firestore/cloud_firestore.dart';

import '../strings.dart';
class Customer {
  final String? id;
  final String name;
  final String? address;
  final String? sourceOfLead;
  final String? phoneNumber;
  List<Customer> potentialCustomers;

  Customer(
      {this.id,
      required this.name,
      required this.address,
      required this.sourceOfLead,
      required this.phoneNumber,
      required this.potentialCustomers});

  factory Customer.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Customer(
        id: data?['id'],
        name: data?['name'],
        address: data?['address'] ?? naString,
        sourceOfLead: data?['sourceOfLead'] ?? naString,
        phoneNumber: data?['phoneNumber'] ?? naString,
        potentialCustomers: (data?['potentialCustomers'] as List<Customer>));
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "name": name,
      "address": address,
      "sourceOfLead": sourceOfLead,
      "phoneNumber": phoneNumber,
      "potentialCustomers": potentialCustomers,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address ?? naString,
      'phoneNumber': phoneNumber ?? naString,
      'sourceOfLead': sourceOfLead ?? naString,
      'potentialCustomers': potentialCustomers,
    };
  }

  Customer.fromDocumentSnapshot(DocumentSnapshot doc) 
    : id = doc.id,
      name = (doc.data() as dynamic)['name'] ?? naString,
      address = (doc.data() as dynamic)["address"] ?? naString,
      sourceOfLead = (doc.data() as dynamic)["sourceOfLead"] ?? naString,
      phoneNumber = (doc.data() as dynamic)["phoneNumber"] ?? naString,
      potentialCustomers = (doc.data() as dynamic)["potentialCustomers"] ?? List.empty();

}
