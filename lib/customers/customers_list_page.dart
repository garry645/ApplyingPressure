import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/customers/customer_info_page.dart';
import 'package:applying_pressure/strings.dart';
import 'package:flutter/material.dart';

import '../database_service.dart';
import 'add_customer_page.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({Key? key}) : super(key: key);
  final String title = "Customers";
  static const routeName = '/customersListPage';

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  DatabaseService service = DatabaseService();
  Future<List<Customer>>? customerList;
  List<Customer> retrievedCustomerList = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    customerList = service.retrieveCustomers();
    retrievedCustomerList = await service.retrieveCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _initRetrieval,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: customerList,
            builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedCustomerList.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return createDismisable(retrievedCustomerList[index]);
                    });
              } else if (snapshot.connectionState == ConnectionState.done
                  && retrievedCustomerList.isEmpty) {
                return createEmptyState();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.pushNamed(context, AddCustomerPage.routeName);
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget createEmptyState() {
    return Center(
      child: ListView(
        children: const <Widget>[
          Align(
              alignment: AlignmentDirectional.center,
              child: Text('No data available')),
        ],
      ),
    );
  }

  Widget createDismisable(Customer customer) {
    return Dismissible(
        onDismissed: ((direction) async {
          await service.deleteCustomer(
              customer.id.toString());
        }),
        background: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.only(right: 28.0),
          alignment: AlignmentDirectional.centerEnd,
          child: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        direction: DismissDirection.endToStart,
        resizeDuration: const Duration(milliseconds: 200),
        key: UniqueKey(),
        child: makeListTile(customer)
    );
  }

  Widget makeListTile(Customer customer) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerInfoPage(customer: customer)));
      },
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5)),
      title: Text(customer.name),
      subtitle:
      Text("${customer.address ?? naString} \n"
          "${customer.phoneNumber ?? naString}"),
      trailing: const Icon(Icons.arrow_right_sharp),
    );
  }
}
