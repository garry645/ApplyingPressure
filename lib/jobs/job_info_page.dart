import 'dart:io';

import 'package:applying_pressure/jobs/job.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/service_provider.dart';
import '../services/interfaces/database_service_interface.dart';
import '../services/interfaces/storage_service_interface.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';
import '../shared/date_time_picker_field.dart';

class JobInfoPage extends StatefulWidget {
  final Job job;

  const JobInfoPage({super.key, required this.job});

  static const routeName = '/jobInfoPage';

  @override
  State<JobInfoPage> createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  final ImagePicker _picker = ImagePicker();
  late DatabaseServiceInterface databaseService;
  late StorageServiceInterface storageService;
  String? receiptImageUrl;

  //File image;

  /*Future<Job> _initRetrieval() async {
    jobId = ModalRoute.of(context)!.settings.arguments as String;
    return service.retrieveJobById(jobId);
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    databaseService = ServiceProvider.getDatabaseService(context);
    storageService = ServiceProvider.getStorageService(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Job>>(
      stream: databaseService.getJobs(),
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
        
        // Find the job with matching ID
        final job = snapshot.data!.firstWhere(
          (j) => j.id == widget.job.id,
          orElse: () => widget.job,
        );
        
        return _jobInfoPage(job);
      },
    );
  }

  Widget _jobInfoPage(Job job) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToEditPage(job);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
          child: Column(children: [
        /*FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the camera controller is initialized, display the camera preview.
                  return Text("Something");
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),*/
        Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(color: Colors.blue[600]),
            child: Wrap(children: [
              Column(
                children: [
                  Text('Status: ${job.title}', style: subTitleText()),
                  const SizedBox(height: 8),

                  Text('Start Date: ${getJobStartDateString(job)}',
                      style: subTitleText()),
                  const SizedBox(height: 8),
                  Text('Projected End Date: ${getJobEndDateString(job)}',
                      style: subTitleText()),
                ],
              )
            ])),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            //TODO
            //job.status = "finished";
            //service.updateJob(widget.job.id, widget.job);
            setState(() {});
          },
          child: const Text('Finish Job'),
        ),
        IconButton(
            onPressed: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);

              if (pickedFile != null) {
                final file = File(pickedFile.path);

                // Upload the image using storage service
                receiptImageUrl = await storageService.uploadFile(
                  file: file,
                  path: 'images',
                  fileName: pickedFile.name,
                );

                // Update the job with the new image URL
                Job updatedJob = Job(
                  id: job.id,
                  title: job.title,
                  address: job.address,
                  startDate: job.startDate,
                  projectedEndDate: job.projectedEndDate,
                  actualEndDate: job.actualEndDate,
                  customer: job.customer,
                  receiptImageUrl: receiptImageUrl,
                );
                await databaseService.updateJob(job.id!, updatedJob);
              }
            },
            icon: const Icon(Icons.camera)),

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

  String getJobStartDateString(Job? job) {
    return '${job?.startDate?.month}/${job?.startDate?.day}/${job?.startDate?.year} '
        '${job?.startDate?.hour.toString().padLeft(2, '0')}:${job?.startDate?.minute?.toString().padLeft(2, '0')}\n\n';
  }

  String getJobEndDateString(Job? job) {
    return '${job?.projectedEndDate?.month}/${job?.projectedEndDate?.day}/${job?.projectedEndDate?.year} '
        '${job?.projectedEndDate?.hour.toString().padLeft(2, '0')}:${job?.projectedEndDate?.minute?.toString().padLeft(2, '0')}\n\n';
  }

  void _navigateToEditPage(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFormPage<Job>(
          existingModel: job,
          fieldConfigs: [
            const FormFieldConfig(
              name: 'title',
              label: 'Title',
              hintText: 'Enter Job Title',
              isRequired: true,
            ),
            const FormFieldConfig(
              name: 'address',
              label: 'Address',
              hintText: 'Enter Job Address',
              isRequired: true,
            ),
            FormFieldConfig(
              name: 'startDate',
              label: '',
              hintText: '',
              customWidget: StatefulBuilder(
                builder: (context, setState) {
                  DateTime startDate = job.startDate ?? DateTime.now();
                  return DateTimePickerField(
                    label: 'Start Date & Time',
                    initialDate: startDate,
                    onDateTimeChanged: (newDate) {
                      startDate = newDate;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FormDataUpdater.of(context)?.updateFormData('startDate', newDate);
                      });
                    },
                  );
                },
              ),
            ),
            FormFieldConfig(
              name: 'projectedEndDate',
              label: '',
              hintText: '',
              customWidget: StatefulBuilder(
                builder: (context, setState) {
                  DateTime projectedEndDate = job.projectedEndDate ?? DateTime.now();
                  return DateTimePickerField(
                    label: 'Projected End Date & Time',
                    initialDate: projectedEndDate,
                    onDateTimeChanged: (newDate) {
                      projectedEndDate = newDate;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FormDataUpdater.of(context)?.updateFormData('projectedEndDate', newDate);
                      });
                    },
                  );
                },
              ),
            ),
          ],
          modelBuilder: (formData) {
            return Job(
              id: job.id,
              title: formData['title']?.toString() ?? job.title,
              address: formData['address']?.toString() ?? job.address,
              startDate: formData['startDate'] as DateTime? ?? job.startDate,
              projectedEndDate: formData['projectedEndDate'] as DateTime? ?? job.projectedEndDate,
              actualEndDate: job.actualEndDate,
              customer: job.customer,
              receiptImageUrl: job.receiptImageUrl,
            );
          },
          onSave: (updatedJob) async {
            await databaseService.updateJob(job.id!, updatedJob);
          },
        ),
      ),
    );
  }
}
