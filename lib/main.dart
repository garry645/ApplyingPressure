import 'widgets/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'services/service_provider.dart';
import 'services/interfaces/auth_service_interface.dart';
import 'services/interfaces/database_service_interface.dart';
import 'services/interfaces/storage_service_interface.dart';
import 'services/firebase/firebase_auth_service.dart';
import 'services/firebase/firebase_database_service.dart';
import 'services/firebase/firebase_storage_service.dart';
import 'home/home_page.dart';
import 'login/login_page.dart';
import 'login/forgot_password_page.dart';
import 'jobs/add_job_page.dart';
import 'customers/add_customer_page.dart';
import 'expenses/add_expense_page.dart';
import 'settings/settings_page.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    print('[MAIN] Loading environment variables...');
    if (kIsWeb) {
      // For web, skip dotenv entirely
      print('[MAIN] Web build detected, using production settings');
      // Don't try to set dotenv.env values, just let the database service use defaults
    } else {
      try {
        await dotenv.load(fileName: ".env");
        print('[MAIN] Environment loaded: ${dotenv.env['ENV']}, USE_TEST_COLLECTIONS: ${dotenv.env['USE_TEST_COLLECTIONS']}');
      } catch (e) {
        print('[MAIN] Error loading .env file: $e');
        print('[MAIN] Continuing with default settings...');
      }
    }
    
    // Initialize Firebase
    print('[MAIN] Initializing Firebase...');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('[MAIN] Firebase initialized successfully');
    } catch (e) {
      print('[MAIN] Firebase initialization error: $e');
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Firebase initialization failed: $e'),
          ),
        ),
      ));
      return;
    }
    
    // Enable Firestore offline persistence (only for mobile/desktop, not web)
    // Web persistence is handled differently and this might cause delays
    if (!kIsWeb) {
      print('[MAIN] Setting up Firestore offline persistence...');
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }
    
    // Initialize services
    print('[MAIN] Initializing services...');
    final authService = FirebaseAuthService();
    final databaseService = FirebaseDatabaseService();
    final storageService = FirebaseStorageService();
    
    print('[MAIN] Starting app...');
    runApp(ApplyingPressureApp(
      authService: authService,
      databaseService: databaseService,
      storageService: storageService,
    ));
  } catch (e, stackTrace) {
    print('[MAIN] Critical error in main: $e');
    print('[MAIN] Stack trace: $stackTrace');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Critical Error: $e'),
              const SizedBox(height: 8),
              const Text('Please check console for details'),
            ],
          ),
        ),
      ),
    ));
  }
}

class ApplyingPressureApp extends StatelessWidget {
  final AuthServiceInterface authService;
  final DatabaseServiceInterface databaseService;
  final StorageServiceInterface storageService;

  const ApplyingPressureApp({
    Key? key,
    required this.authService,
    required this.databaseService,
    required this.storageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      authService: authService,
      databaseService: databaseService,
      storageService: storageService,
      child: MaterialApp(
        title: 'Applying Pressure',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WidgetTree(),
        routes: {
          Routes.home: (context) => const HomePage(),
          Routes.login: (context) => const LoginPage(),
          Routes.forgotPassword: (context) => const ForgotPasswordPage(),
          Routes.addJob: (context) => const AddJobPage(),
          Routes.addCustomer: (context) => const AddCustomerPage(),
          Routes.addExpense: (context) => const AddExpensePage(),
          Routes.settings: (context) => const SettingsPage(),
        },
      ),
    );
  }
}

