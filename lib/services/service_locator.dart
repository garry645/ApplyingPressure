import 'interfaces/auth_service_interface.dart';
import 'interfaces/database_service_interface.dart';
import 'interfaces/storage_service_interface.dart';
import 'firebase/firebase_auth_service.dart';
import 'firebase/firebase_database_service.dart';
import 'firebase/firebase_storage_service.dart';

/// Service locator for accessing services outside of the widget tree
/// This maintains backward compatibility with the singleton pattern
class ServiceLocator {
  static ServiceLocator? _instance;
  
  late final AuthServiceInterface authService;
  late final DatabaseServiceInterface databaseService;
  late final StorageServiceInterface storageService;

  ServiceLocator._({
    AuthServiceInterface? auth,
    DatabaseServiceInterface? database,
    StorageServiceInterface? storage,
  }) {
    authService = auth ?? FirebaseAuthService();
    databaseService = database ?? FirebaseDatabaseService();
    storageService = storage ?? FirebaseStorageService();
  }

  factory ServiceLocator({
    AuthServiceInterface? auth,
    DatabaseServiceInterface? database,
    StorageServiceInterface? storage,
  }) {
    _instance ??= ServiceLocator._(
      auth: auth,
      database: database,
      storage: storage,
    );
    return _instance!;
  }

  /// Reset the instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  /// Initialize with custom services (useful for testing)
  static void initialize({
    AuthServiceInterface? auth,
    DatabaseServiceInterface? database,
    StorageServiceInterface? storage,
  }) {
    _instance = ServiceLocator._(
      auth: auth,
      database: database,
      storage: storage,
    );
  }
}