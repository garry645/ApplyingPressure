import 'package:flutter/material.dart';

Widget cameraButton() {
  return ElevatedButton(
    style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(200, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 83, 80, 80))),
    onPressed: (() {

    }),
    child: const Icon(
      Icons.camera,
      size: 24.0,
      semanticLabel: 'Take Picture',
    ),
  );
}
