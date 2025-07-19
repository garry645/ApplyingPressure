import 'package:applying_pressure/customers/customer.dart';
import 'package:flutter/material.dart';

import '../strings.dart';

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
                      Text('${widget.customer.name}\n\n', style: headerText()),
                      Text('${widget.customer.phoneNumber}\n\n', style: headerText()),
                      Column(children: [
                        Text('Address: ', style: subTitleText()),
                        Text(widget.customer.address ?? naString, style: subTitleText()),
                      ]),
                      const SizedBox(width: 8),
                      Column(children: [
                        Text('Source Of Lead: ', style: subTitleText()),
                        Text(widget.customer.sourceOfLead ?? naString, style: subTitleText()),
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