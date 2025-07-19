import 'package:flutter/material.dart';

import '../services/service_provider.dart';
import '../services/interfaces/database_service_interface.dart';
import 'job.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  static const routeName = '/addJobPage';

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late DateTime startDate;
  late DateTime projectedEndDate;
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    projectedEndDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

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
    titleController.dispose();
    addressController.dispose();
    super.dispose();
  }

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
                          const Text('Address'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Address", addressController),
                          Text('Start Date & Time: '
                              '${startDate.month}/${startDate.day}/${startDate.year}\t'
                              '${startDate.hour}:${startDate.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 18.0)),
                          const SizedBox(height: 4.0),
                          ElevatedButton(
                              onPressed: pickStartDateTime,
                              child: const Text("Select Date & Time")),
                          Text('Projected End Date & Time: '
                              '${projectedEndDate.month}/${projectedEndDate.day}/${projectedEndDate.year}\t'
                              '${projectedEndDate.hour}:${projectedEndDate.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 18.0)),
                          const SizedBox(height: 4.0),
                          ElevatedButton(
                              onPressed: pickEndDateTime,
                              child: const Text("Select Date & Time")),
                          const SizedBox(height: 8.0),
                          !isLoading
                              ? _createSubmitButton()
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ])))));
  }

  Future<DateTime> pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }

    TimeOfDay? time = await pickTime();
    if (time == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }

    final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
    );

    return dateTime;
  }

  Future pickStartDateTime() async {
    DateTime startDateTime = await pickDateTime();
    setState(() => startDate = startDateTime);
  }

  Future pickEndDateTime() async {
    DateTime endDateTime = await pickDateTime();
    setState(() => projectedEndDate = endDateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 00));

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
                  final service = ServiceProvider.getDatabaseService(context);
                  Job job = Job(
                    title: titleController.text,
                    address: addressController.text,
                    startDate: startDate,
                    projectedEndDate: projectedEndDate);

              setState(() {
                isLoading = true;
              });
              await service.addJob(job);
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
