import 'package:flutter/material.dart';
import '../routes.dart';
import '../services/service_provider.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';
import 'expense.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  static const routeName = Routes.addExpense;

  @override
  Widget build(BuildContext context) {
    return EditFormPage<Expense>(
      fieldConfigs: [
        const FormFieldConfig(
          name: 'name',
          label: 'Name',
          hintText: 'Enter Expense Name',
          isRequired: true,
        ),
        FormFieldConfig(
          name: 'cost',
          label: 'Cost',
          hintText: 'Enter Expense Cost',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Expense Cost';
            }
            final cost = double.tryParse(value);
            if (cost == null || cost < 0) {
              return 'Please enter a valid cost';
            }
            return null;
          },
        ),
        const FormFieldConfig(
          name: 'description',
          label: 'Description',
          hintText: 'Enter Expense Description',
          isRequired: true,
          maxLines: 3,
        ),
      ],
      modelBuilder: (formData) {
        return Expense(
          name: formData['name'] as String,
          cost: double.parse(formData['cost'] as String),
          description: formData['description'] as String,
        );
      },
      onSave: (expense) async {
        final service = ServiceProvider.getDatabaseService(context);
        await service.addExpense(expense);
      },
    );
  }
}