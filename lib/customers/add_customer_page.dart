import 'package:flutter/material.dart';

import '../services/service_provider.dart';
import '../services/interfaces/database_service_interface.dart';
import 'customer.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  static const routeName = '/addCustomerPage';

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );

  final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          )));

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Customer to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Customer"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Name'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Name", nameController),
                          const SizedBox(height: 8.0),
                          const Text('Address'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Address", addressController),
                          const SizedBox(height: 8.0),
                          const Text('Phone Number'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Phone Number", phoneNumberController),
                          const SizedBox(height: 8.0),
                          const Text('Source Of Lead'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Source Of Lead", sourceController),
                          const SizedBox(height: 8.0),
                          !isLoading
                              ? _createSubmitButton()
                              : const Center(
                                child: CircularProgressIndicator()),
                        ]
                    )
                )
            )
        )
    );
  }

  Widget _createTextFormField(String field, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: inputDecoration.copyWith(hintText: "Enter Customer $field"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Customer $field';
            }
            return null;
          },
        ));
  }

  Widget _createSubmitButton() {
    return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 83, 80, 80))),
              onPressed: (() async {
                if (_formKey.currentState!.validate()) {
                  DatabaseServiceInterface service = ServiceProvider.getDatabaseService(context);
                  Customer customer = Customer(
                      name: nameController.text,
                      address: addressController.text,
                      phoneNumber: phoneNumberController.text,
                      sourceOfLead: sourceController.text,
                      potentialCustomers: List.empty()
                  );

                  setState(() {
                    isLoading = true;
                  });
                  await service.addCustomer(customer);
                  setState(() {
                    isLoading = false;
                  });
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              }),
              child: const Text("Submit", style: TextStyle(fontSize: 20))),
        ));
  }
}
