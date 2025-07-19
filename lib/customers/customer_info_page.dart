import 'package:applying_pressure/customers/customer.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import '../strings.dart';
import '../services/service_provider.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';

const String loadingString = "Loading";

class CustomerInfoPage extends StatefulWidget {
  final Customer customer;
  // In the constructor, require a Customer.
  const CustomerInfoPage({super.key, required this.customer});

  static const routeName = '/customerInfoPage';

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();

}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  @override
  Widget build(BuildContext context) {
    final databaseService = ServiceProvider.getDatabaseService(context);
    
    return StreamBuilder<Customer?>(
      stream: databaseService.getCustomerStreamById(widget.customer.id!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        final customer = snapshot.data!;
        return _buildCustomerInfo(customer);
      },
    );
  }
  
  Widget _buildCustomerInfo(Customer customer) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToEditPage(customer);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(color: Colors.blue[600]),
                child: Wrap(children: [
                  Column(
                    children: [
                      Text('${customer.name}\n\n', style: headerText()),
                      Text('${customer.phoneNumber}\n\n', style: headerText()),
                      Column(children: [
                        Text('Address: ', style: subTitleText()),
                        Text(customer.address ?? naString, style: subTitleText()),
                      ]),
                      const SizedBox(width: 8),
                      Column(children: [
                        Text('Source Of Lead: ', style: subTitleText()),
                        Text(customer.sourceOfLead ?? naString, style: subTitleText()),
                      ])
                    ],
                  )
                ])),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.addJob,
                  arguments: customer,
                );
              },
              child: const Text('Create Job for Customer'),
            )
          ])),
    );
  }

  TextStyle headerText() {
    return const TextStyle(
        fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white);
  }

  TextStyle subTitleText() {
    return const TextStyle(fontSize: 13, color: Colors.white);
  }

  void _navigateToEditPage(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFormPage<Customer>(
          existingModel: customer,
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
              id: customer.id,
              name: formData['name']?.toString() ?? customer.name,
              address: formData['address']?.toString() ?? customer.address,
              phoneNumber: formData['phoneNumber']?.toString() ?? customer.phoneNumber,
              sourceOfLead: formData['sourceOfLead']?.toString() ?? customer.sourceOfLead,
              potentialCustomers: customer.potentialCustomers,
            );
          },
          onSave: (updatedCustomer) async {
            final service = ServiceProvider.getDatabaseService(context);
            await service.updateCustomer(customer.id!, updatedCustomer);
          },
        ),
      ),
    );
  }
}