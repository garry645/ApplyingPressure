import 'package:applying_pressure/widgets/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ApplyingPressureApp());
}

class ApplyingPressureApp extends StatelessWidget {
  const ApplyingPressureApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applying Pressure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree()
    );
  }
}

