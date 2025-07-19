import 'package:flutter/material.dart';

/// Configuration for a form field in the generic edit form
class FormFieldConfig {
  final String name;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? customWidget;
  final bool isRequired;
  final int? maxLines;
  final String? initialValue;
  final void Function(String)? onChanged;

  const FormFieldConfig({
    required this.name,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.customWidget,
    this.isRequired = true,
    this.maxLines = 1,
    this.initialValue,
    this.onChanged,
  });

  /// Default validator that checks for required fields
  String? defaultValidator(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Please enter $label:';
    }
    return validator?.call(value);
  }

  /// Creates a text form field based on this configuration
  Widget buildFormField(
    BuildContext context,
    TextEditingController controller,
    InputDecoration baseDecoration,
  ) {
    // If custom widget is provided, use it instead
    if (customWidget != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:'),
          const SizedBox(height: 8.0),
          customWidget!,
        ],
      );
    }

    // Otherwise create a standard text form field
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:'),
        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: baseDecoration.copyWith(hintText: hintText),
            validator: defaultValidator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Type of form (Add or Edit)
enum FormMode { add, edit }