/// Interface for models that can be edited in the generic edit form
abstract class EditableModel {
  /// Converts the model to a map for form data
  Map<String, dynamic> toFormData();
  
  /// Gets the display name for this model type (e.g., "Job", "Customer", "Expense")
  String get modelTypeName;
  
  /// Gets the ID if this is an existing model (for editing)
  String? get id;
}