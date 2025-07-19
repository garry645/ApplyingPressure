import 'package:flutter/material.dart';
import '../database_service.dart';
import 'expense.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  static const routeName = '/addExpensePage';

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController costController = TextEditingController();//MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ','); //after


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
    descriptionController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Expense to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Expense"),
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
                          const Text('Cost'),
                          const SizedBox(height: 8.0),
                          _createMoneyFormField("Cost", costController),
                          const SizedBox(height: 8.0),
                          const Text('Description'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Description", descriptionController),
                          const SizedBox(height: 8.0),
                          !isLoading ? _createSubmitButton()
                              : const Center(child: CircularProgressIndicator()),
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
          decoration: inputDecoration.copyWith(hintText: "Enter Expense $field"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Expense $field';
            }
            return null;
          },
        ));
  }

  Widget _createMoneyFormField(String field, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: inputDecoration.copyWith(hintText: "Enter Expense $field"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Expense $field';
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
                  DatabaseService service = DatabaseService();
                  Expense expense = Expense(
                      name: nameController.text,
                      description: descriptionController.text,
                      cost: double.parse(costController.text));

                  setState(() {
                    isLoading = true;
                  });
                  await service.addExpense(expense);
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