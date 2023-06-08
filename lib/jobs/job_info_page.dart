import 'dart:io';

import 'package:applying_pressure/jobs/job.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database_service.dart';

class JobInfoPage extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> jobDoc;

  const JobInfoPage({super.key, required this.jobDoc});

  static const routeName = '/jobInfoPage';

  @override
  State<JobInfoPage> createState() => _JobInfoPageState();
}

class _JobInfoPageState extends State<JobInfoPage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  DatabaseService service = DatabaseService();
  String? receiptImageUrl;

  //File image;

  /*Future<Job> _initRetrieval() async {
    jobId = ModalRoute.of(context)!.settings.arguments as String;
    return service.retrieveJobById(jobId);
  }*/

  @override
  Widget build(BuildContext context) {
    Job job = Job.fromJson(widget.jobDoc.data());
    // Use the Job to create the UI.
    return _jobInfoPage(job); /*FutureBuilder<Job>(future: _initRetrieval(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("data");//_jobInfoPage(Job(title: "Error", address: "Error"));
          } else if (snapshot.hasData) {
            Job job = snapshot.data!;
            return Text("data");//_jobInfoPage(job);
          } else {
            return Text("data");//_jobInfoPage(Job(title: "Loading", address: "Loading"));
          }
        });*/
  }

  Widget _jobInfoPage(Job job) {
    return Scaffold(
      appBar: AppBar(),
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

                final ref = _storage.ref().child('images/${pickedFile.name}');
                await ref.putFile(file);

                // Get the download URL of the image
                receiptImageUrl = await ref.getDownloadURL();

                // Update the image URL in Firestore
                await widget.jobDoc.reference.update({
                  'receiptImageUrl': receiptImageUrl,
                });
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
        '${job?.startDate?.hour}:${job?.startDate?.minute}\n\n';
  }

  String getJobEndDateString(Job? job) {
    return '${job?.projectedEndDate?.month}/${job?.projectedEndDate?.day}/${job?.projectedEndDate?.year} '
        '${job?.projectedEndDate?.hour}:${job?.projectedEndDate?.minute}\n\n';
  }
}
