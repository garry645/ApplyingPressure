import 'package:flutter/material.dart';
import '../routes.dart';
import '../services/service_provider.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';
import 'customer.dart';

class AddCustomerPage extends StatelessWidget {
  const AddCustomerPage({super.key});

  static const routeName = Routes.addCustomer;

  @override
  Widget build(BuildContext context) {
    return EditFormPage<Customer>(
      fieldConfigs: const [
        FormFieldConfig(
          name: 'name',
          label: 'Name',
          hintText: 'Enter Customer Name',
          isRequired: true,
        ),
        FormFieldConfig(
          name: 'address',
          label: 'Address',
          hintText: 'Enter Customer Address',
          isRequired: true,
        ),
        FormFieldConfig(
          name: 'phoneNumber',
          label: 'Phone Number',
          hintText: 'Enter Customer Phone Number',
          keyboardType: TextInputType.phone,
          isRequired: true,
        ),
        FormFieldConfig(
          name: 'sourceOfLead',
          label: 'Source Of Lead',
          hintText: 'Enter Customer Source Of Lead',
          isRequired: true,
        ),
      ],
      modelBuilder: (formData) {
        return Customer(
          name: formData['name'] as String,
          address: formData['address'] as String,
          phoneNumber: formData['phoneNumber'] as String,
          sourceOfLead: formData['sourceOfLead'] as String,
          potentialCustomers: [],
        );
      },
      onSave: (customer) async {
        final service = ServiceProvider.getDatabaseService(context);
        await service.addCustomer(customer);
      },
    );
  }
}