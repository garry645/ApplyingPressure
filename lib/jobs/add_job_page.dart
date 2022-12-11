import 'package:flutter/material.dart';

import '../database_service.dart';
import 'job.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});
  static const routeName = '/addJobPage';

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController projectedEndDateController = TextEditingController();
  TextEditingController actualEndDateController = TextEditingController();

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
  Widget build(BuildContext context) {
    // Use the Job to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Job"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Title'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Title", titleController),
                          const Text('Start Date'),
                          const SizedBox(height: 8.0),
                          _createTextFormField(
                              "Start Date", startDateController),
                          const Text('Projected End Date'),
                          const SizedBox(height: 8.0),
                          _createTextFormField(
                              "Projected End Date", projectedEndDateController),
                          const Text('Actual End Date'),
                          const SizedBox(height: 8.0),
                          _createTextFormField(
                              "Actual End Date", actualEndDateController),
                          !isLoading
                              ? _createSubmitButton()
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ])))));
  }

  Widget _createTextFormField(String field, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: inputDecoration.copyWith(hintText: "Enter Job $field"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Job $field';
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
                  Job job = Job(
                    title: titleController.text,
                    startDate: startDateController.text,
                    projectedEndDate: projectedEndDateController.text,
                    actualEndDate: actualEndDateController.text);

                  setState(() {
                    isLoading = true;
                  });
                  await service.addJob(job);
                  setState(() {
                    isLoading = false;
                  });
                }
              }),
              child: const Text("Submit", style: TextStyle(fontSize: 20))
          ),
    ));
    /*:
    )*/
  }
}
