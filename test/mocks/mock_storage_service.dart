import 'dart:io';
import 'package:applying_pressure/services/interfaces/storage_service_interface.dart';

class MockStorageService implements StorageServiceInterface {
  final Map<String, String> _storage = {};
  
  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    required String fileName,
  }) async {
    // Simulate upload delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Generate a mock URL
    final fullPath = '$path/$fileName';
    final mockUrl = 'https://mock-storage.example.com/$fullPath';
    
    // Store the mapping
    _storage[fullPath] = mockUrl;
    
    return mockUrl;
  }
  
  @override
  Future<void> deleteFile(String path) async {
    // Simulate deletion delay
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Remove from storage
    _storage.remove(path);
  }
  
  @override
  Future<String> getDownloadUrl(String path) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 50));
    
    final url = _storage[path];
    if (url != null) {
      return url;
    }
    throw Exception('File not found: $path');
  }
  
  // Helper methods for testing
  void clearAll() {
    _storage.clear();
  }
  
  bool hasFile(String path) {
    return _storage.containsKey(path);
  }
}