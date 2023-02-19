import 'package:applying_pressure/customers/customer.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import '../strings.dart';

const String loadingString = "Loading";

class CustomerInfoPage extends StatefulWidget {
  // In the constructor, require a Customer.
  const CustomerInfoPage({super.key});

  static const routeName = '/customerInfoPage';

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();

}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  DatabaseService service = DatabaseService();
  Customer customer = Customer(
    id: loadingString,
    name: loadingString,
    address: loadingString,
    sourceOfLead: loadingString,
    phoneNumber: loadingString,
    potentialCustomers: List.empty());
  String customerId = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initRetrieval();
    });
  }

  Future<void> _initRetrieval() async {
    customerId = ModalRoute.of(context)!.settings.arguments as String;
    customer = await service.retrieveCustomerById(customerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final customer = ModalRoute.of(context)!.settings.arguments as Customer;
    // Use the Customer to create the UI.
    return Scaffold(
      appBar: AppBar(),
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
}