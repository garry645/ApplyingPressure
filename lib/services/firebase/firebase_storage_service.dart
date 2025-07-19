import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../interfaces/storage_service_interface.dart';

/// Firebase implementation of StorageServiceInterface
class FirebaseStorageService implements StorageServiceInterface {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    required String fileName,
  }) async {
    final ref = _storage.ref().child(path).child(fileName);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Future<void> deleteFile(String path) async {
    await _storage.ref(path).delete();
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}