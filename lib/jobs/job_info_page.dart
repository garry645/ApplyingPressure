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
                  Text('Status: ${job.status}', style: subTitleText()),
                  const SizedBox(height: 8),

                  Text('Start Date: ${getJobStartDateString(job)}',
                      style: subTitleText()),
                  const SizedBox(height: 8),
                  Text('Projected End Date: ${getJobEndDateString(job)}',
                      style: subTitleText()),
                ],
              )
            ])),
        const SizedBox(height: 20),
        _buildStatusButtons(job),
        const SizedBox(height: 10),
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

  Widget _buildStatusButtons(Job job) {
    final statusFlow = ['Planned', 'Started', 'In Progress', 'Finished'];
    final currentIndex = statusFlow.indexOf(job.status);
    
    // Determine next status
    String? nextStatus;
    String buttonText;
    
    if (currentIndex >= 0 && currentIndex < statusFlow.length - 1) {
      nextStatus = statusFlow[currentIndex + 1];
      buttonText = 'Mark as $nextStatus';
    } else if (job.status == 'Pending') {
      // Handle legacy "Pending" status
      nextStatus = 'Planned';
      buttonText = 'Start Planning';
    } else if (job.status == 'Finished') {
      // Cycle back to Planned
      nextStatus = 'Planned';
      buttonText = 'Reset to Planned';
    } else {
      buttonText = 'Job Completed';
    }
    
    return Column(
      children: [
        // Show current status with appropriate color
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(job.status),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Current Status: ${job.status}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Status progression button
        if (nextStatus != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(200, 45),
            ),
            onPressed: () async {
              try {
                final updatedJob = job.copyWith(
                  status: nextStatus,
                  actualEndDate: nextStatus == 'Finished' ? DateTime.now() : 
                                nextStatus == 'Planned' && job.status == 'Finished' ? null : 
                                job.actualEndDate,
                );
                await databaseService.updateJob(job.id!, updatedJob);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating job: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(buttonText),
          ),
      ],
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Planned':
        return Colors.orange;
      case 'Started':
        return Colors.blue;
      case 'In Progress':
        return Colors.green;
      case 'Finished':
        return Colors.grey;
      case 'Pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
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
              name: 'status',
              label: 'Status',
              hintText: 'Select Status',
              initialValue: job.status,
              customWidget: DropdownButtonFormField<String>(
                value: job.status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'Planned', 'Started', 'In Progress', 'Finished']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    FormDataUpdater.of(context)?.updateFormData('status', value);
                  }
                },
              ),
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
              status: formData['status']?.toString() ?? job.status,
              address: formData['address']?.toString() ?? job.address,
              startDate: formData['startDate'] as DateTime? ?? job.startDate,
              projectedEndDate: formData['projectedEndDate'] as DateTime? ?? job.projectedEndDate,
              actualEndDate: job.actualEndDate,
              customer: job.customer,
              customerId: job.customerId,
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
