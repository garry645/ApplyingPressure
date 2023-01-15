import 'package:applying_pressure/customers/customer.dart';
import 'package:flutter/material.dart';

class CustomerInfoPage extends StatelessWidget {
  // In the constructor, require a Customer.
  const CustomerInfoPage({super.key});
  static const routeName = '/customerInfoPage';

  @override
  Widget build(BuildContext context) {
    final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    // Use the Customer to create the UI.
    return Scaffold(
      appBar: AppBar(
        //title: Text(customer.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Name: ${customer.name}\n\n"
            "Address: ${customer.address} \n\n"
            "Source of Lead: ${customer.sourceOfLead}\n\n")
      ),
    );
  }
}