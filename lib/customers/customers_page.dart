import 'package:flutter/material.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}


class _CustomersPageState extends State<CustomersPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Fuckin"),
              ],
            )
        )
    );
  }
}