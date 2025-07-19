import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:applying_pressure/services/service_provider.dart';
import 'package:applying_pressure/services/interfaces/auth_service_interface.dart';
import 'package:applying_pressure/services/interfaces/database_service_interface.dart';
import 'package:applying_pressure/services/interfaces/storage_service_interface.dart';
import 'firebase_mock.dart';
import 'mocks/mock_auth_service.dart';
import 'mocks/mock_database_service.dart';
import 'mocks/mock_storage_service.dart';

// Initialize test environment
Future<void> initializeTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Load test environment variables
  dotenv.testLoad(fileInput: 'USE_TEST_COLLECTIONS=true');
  
  // Setup Firebase mocks
  setupFirebaseMocks();
}

// Create mock services for testing
class TestServices {
  final MockAuthService authService = MockAuthService();
  final MockDatabaseService databaseService = MockDatabaseService();
  final MockStorageService storageService = MockStorageService();
  
  void dispose() {
    authService.dispose();
    databaseService.dispose();
  }
}

// Widget wrapper for tests with ServiceProvider
Widget createTestWidget(
  Widget child, {
  AuthServiceInterface? authService,
  DatabaseServiceInterface? databaseService,
  StorageServiceInterface? storageService,
}) {
  final testServices = TestServices();
  
  return ServiceProvider(
    authService: authService ?? testServices.authService,
    databaseService: databaseService ?? testServices.databaseService,
    storageService: storageService ?? testServices.storageService,
    child: MaterialApp(
      home: child,
    ),
  );
}

// Pump widget with ServiceProvider
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget widget, {
  AuthServiceInterface? authService,
  DatabaseServiceInterface? databaseService,
  StorageServiceInterface? storageService,
}) async {
  await tester.pumpWidget(createTestWidget(
    widget,
    authService: authService,
    databaseService: databaseService,
    storageService: storageService,
  ));
}