import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:applying_pressure/login/forgot_password_page.dart';
import 'package:applying_pressure/services/service_provider.dart';
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
      child: const MaterialApp(
        home: ForgotPasswordPage(),
      ),
    );
  }

  testWidgets('ForgotPasswordPage shows email input field', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Enter your email address and we\'ll send you a link to reset your password.'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Send Password Reset Email'), findsOneWidget);
  });

  testWidgets('Shows error for empty email', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Send Password Reset Email'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('Shows error for invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField), 'invalid-email');
    await tester.tap(find.text('Send Password Reset Email'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Shows success message when email is sent', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    await tester.tap(find.text('Send Password Reset Email'));
    await tester.pumpAndSettle();

    expect(find.text('Password reset email sent! Please check your inbox.'), findsOneWidget);
  });

  testWidgets('Clears email field after successful submission', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final emailField = find.byType(TextFormField);
    await tester.enterText(emailField, 'test@example.com');
    await tester.tap(find.text('Send Password Reset Email'));
    await tester.pumpAndSettle();

    final textFormField = tester.widget<TextFormField>(emailField);
    expect(textFormField.controller!.text, isEmpty);
  });

  testWidgets('Button text and loading state work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Initially button should be visible
    expect(find.text('Send Password Reset Email'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Enter valid email and submit
    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    await tester.tap(find.text('Send Password Reset Email'));
    
    // Let the operation complete
    await tester.pumpAndSettle();
    
    // After completion, button should be visible again
    expect(find.text('Send Password Reset Email'), findsOneWidget);
  });

  testWidgets('Navigation works with back button', (WidgetTester tester) async {
    await tester.pumpWidget(ServiceProvider(
      authService: mockAuthService,
      databaseService: mockDatabaseService,
      storageService: mockStorageService,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: const Text('Go to Forgot Password'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Go to Forgot Password'));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsNothing);
    expect(find.text('Go to Forgot Password'), findsOneWidget);
  });
}