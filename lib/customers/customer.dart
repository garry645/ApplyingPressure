import 'package:cloud_firestore/cloud_firestore.dart';

import '../strings.dart';
import '../shared/editable_model.dart';
class Customer extends EditableModel {
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
        id: snapshot.id,
        name: data?['name'] ?? '',
        address: data?['address'] ?? naString,
        sourceOfLead: data?['sourceOfLead'] ?? naString,
        phoneNumber: data?['phoneNumber'] ?? naString,
        potentialCustomers: []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "name": name,
      "address": address,
      "sourceOfLead": sourceOfLead,
      "phoneNumber": phoneNumber,
      // "potentialCustomers": potentialCustomers, // Complex objects need special handling
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address ?? naString,
      'phoneNumber': phoneNumber ?? naString,
      'sourceOfLead': sourceOfLead ?? naString,
      // 'potentialCustomers': potentialCustomers, // Complex objects need special handling
    };
  }

  Customer.fromDocumentSnapshot(DocumentSnapshot doc) 
    : id = doc.id,
      name = (doc.data() as dynamic)['name'] ?? '',
      address = (doc.data() as dynamic)["address"] ?? naString,
      sourceOfLead = (doc.data() as dynamic)["sourceOfLead"] ?? naString,
      phoneNumber = (doc.data() as dynamic)["phoneNumber"] ?? naString,
      potentialCustomers = [];

  @override
  Map<String, dynamic> toFormData() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'sourceOfLead': sourceOfLead,
    };
  }

  @override
  String get modelTypeName => 'Customer';

  Customer copyWith({
    String? id,
    String? name,
    String? address,
    String? sourceOfLead,
    String? phoneNumber,
    List<Customer>? potentialCustomers,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      sourceOfLead: sourceOfLead ?? this.sourceOfLead,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      potentialCustomers: potentialCustomers ?? this.potentialCustomers,
    );
  }
}
