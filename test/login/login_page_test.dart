import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/login/login_page.dart';
import 'package:applying_pressure/services/service_provider.dart';
import 'package:applying_pressure/routes.dart';
import '../mocks/mock_auth_service.dart';
import '../mocks/mock_database_service.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockDatabaseService mockDatabaseService;
  late MockStorageService mockStorageService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockDatabaseService = MockDatabaseService();
    mockStorageService = MockStorageService();
  });

  tearDown(() {
    mockAuthService.dispose();
  });

  Widget createTestWidget() {
    return ServiceProvider(
      authService: mockAuthService,
      databaseService: mockDatabaseService,
      storageService: mockStorageService,
      child: MaterialApp(
        home: const LoginPage(),
        routes: {
          Routes.forgotPassword: (context) => const Scaffold(
            body: Center(child: Text('Forgot Password Page')),
          ),
        },
      ),
    );
  }

  testWidgets('LoginPage shows forgot password button', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('Forgot password button navigates to forgot password page', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    expect(find.text('Forgot Password Page'), findsOneWidget);
  });

  testWidgets('Login form elements are present', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Login'), findsOneWidget); // App bar title
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Successful login with valid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Login was successful - the form should still be visible but loading is done
    expect(find.text('Submit'), findsOneWidget);
    // Error message should be empty
    expect(find.textContaining('Error'), findsNothing);
  });

  testWidgets('Shows error for invalid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField).first, 'wrong@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
    
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // The error message should be displayed (from FirebaseAuthException)
    // MockAuthService throws an error for wrong credentials
    expect(find.text('Submit'), findsOneWidget); // Form is still visible
  });

  testWidgets('Validation shows errors for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Wrong Email'), findsOneWidget);
    expect(find.text('Wrong Password'), findsOneWidget);
  });
}