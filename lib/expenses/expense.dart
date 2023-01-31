import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id;
  final String name;
  final double cost;
  final String description;

  Expense(
      {this.id,
        required this.name,
        required this.cost,
        required this.description});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cost': cost,
      'description': description
    };
  }

  Expense.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = (doc.data() as dynamic)['name'] ?? "N/A",
        cost = (doc.data() as dynamic)['cost'] ?? 00.00,
        description = (doc.data() as dynamic)['description'] ?? "N/A";
}
