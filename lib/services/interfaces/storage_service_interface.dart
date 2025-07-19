import 'dart:io';

/// Abstract interface for storage operations
abstract class StorageServiceInterface {
  Future<String> uploadFile({
    required File file,
    required String path,
    required String fileName,
  });
  
  Future<void> deleteFile(String path);
  
  Future<String> getDownloadUrl(String path);
}