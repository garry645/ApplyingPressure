import 'package:cloud_firestore/cloud_firestore.dart';
import '../shared/editable_model.dart';

class Expense extends EditableModel {
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

  @override
  Map<String, dynamic> toFormData() {
    return {
      'name': name,
      'cost': cost.toString(),
      'description': description,
    };
  }

  @override
  String get modelTypeName => 'Expense';

  Expense copyWith({
    String? id,
    String? name,
    double? cost,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      description: description ?? this.description,
    );
  }
}
