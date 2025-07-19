import 'package:flutter/material.dart';
import 'interfaces/auth_service_interface.dart';
import 'interfaces/database_service_interface.dart';
import 'interfaces/storage_service_interface.dart';

/// Provides services to the widget tree using InheritedWidget
class ServiceProvider extends InheritedWidget {
  final AuthServiceInterface authService;
  final DatabaseServiceInterface databaseService;
  final StorageServiceInterface storageService;

  const ServiceProvider({
    Key? key,
    required this.authService,
    required this.databaseService,
    required this.storageService,
    required Widget child,
  }) : super(key: key, child: child);

  static ServiceProvider of(BuildContext context) {
    final ServiceProvider? result = context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
    assert(result != null, 'No ServiceProvider found in context');
    return result!;
  }

  static AuthServiceInterface getAuthService(BuildContext context) {
    return of(context).authService;
  }

  static DatabaseServiceInterface getDatabaseService(BuildContext context) {
    return of(context).databaseService;
  }

  static StorageServiceInterface getStorageService(BuildContext context) {
    return of(context).storageService;
  }

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) {
    return authService != oldWidget.authService ||
           databaseService != oldWidget.databaseService ||
           storageService != oldWidget.storageService;
  }
}