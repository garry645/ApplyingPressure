import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectivityCheck {
  static Future<bool> checkFirebaseConnection() async {
    try {
      // Try to fetch a minimal document to check connection
      await FirebaseFirestore.instance
          .collection('test')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      return false;
    }
  }
}