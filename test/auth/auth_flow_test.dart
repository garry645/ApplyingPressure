import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/login/login_page.dart';
import 'package:applying_pressure/login/forgot_password_page.dart';
import 'package:applying_pressure/settings/settings_page.dart';
import 'package:applying_pressure/widgets/widget_tree.dart';
import 'package:applying_pressure/home/home_page.dart';
import 'package:applying_pressure/services/service_provider.dart';
import 'package:applying_pressure/routes.dart';
import '../mocks/mock_auth_service.dart';
import '../mocks/mock_database_service.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('Authentication Flow Tests', () {
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

    Widget createTestApp({Widget? home}) {
      return ServiceProvider(
        authService: mockAuthService,
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
        child: MaterialApp(
          home: home ?? const WidgetTree(),
          routes: {
            Routes.login: (context) => const LoginPage(),
            Routes.forgotPassword: (context) => const ForgotPasswordPage(),
            Routes.settings: (context) => const SettingsPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(builder: (_) => const WidgetTree());
            }
            return null;
          },
        ),
      );
    }

    group('Login Page', () {
      testWidgets('shows all required elements', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const LoginPage()));

        expect(find.text('Login'), findsOneWidget); // App bar
        expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password
        expect(find.text('Submit'), findsOneWidget);
        expect(find.text('Forgot Password?'), findsOneWidget);
      });

      testWidgets('validates empty fields', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const LoginPage()));

        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        expect(find.text('Wrong Email'), findsOneWidget);
        expect(find.text('Wrong Password'), findsOneWidget);
      });

      testWidgets('successful login updates auth state', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const LoginPage()));

        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        expect(mockAuthService.currentUser, isNotNull);
        expect(mockAuthService.currentUser!.email, equals('test@example.com'));
      });

      testWidgets('navigates to forgot password page', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const LoginPage()));

        await tester.tap(find.text('Forgot Password?'));
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordPage), findsOneWidget);
      });
    });

    group('Forgot Password Page', () {
      testWidgets('shows all required elements', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const ForgotPasswordPage()));

        expect(find.text('Reset Password'), findsOneWidget);
        expect(find.text('Enter your email address and we\'ll send you a link to reset your password.'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Send Password Reset Email'), findsOneWidget);
      });

      testWidgets('validates email format', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const ForgotPasswordPage()));

        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        await tester.tap(find.text('Send Password Reset Email'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('shows success message and clears field', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const ForgotPasswordPage()));

        final emailField = find.byType(TextFormField);
        await tester.enterText(emailField, 'test@example.com');
        await tester.tap(find.text('Send Password Reset Email'));
        await tester.pumpAndSettle();

        expect(find.text('Password reset email sent! Please check your inbox.'), findsOneWidget);
        
        final textFormField = tester.widget<TextFormField>(emailField);
        expect(textFormField.controller!.text, isEmpty);
      });
    });

    group('Logout Flow', () {
      setUp(() {
        // Set up authenticated user
        final mockUser = MockUser(email: 'test@example.com');
        mockAuthService.setCurrentUser(mockUser);
      });

      testWidgets('logout button signs out user', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const SettingsPage()));

        expect(mockAuthService.currentUser, isNotNull);

        await tester.tap(find.text('Log Out'));
        await tester.pump();

        expect(mockAuthService.currentUser, isNull);
      });

      testWidgets('settings page shows user info and logout', (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp(home: const SettingsPage()));

        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('User Information'), findsOneWidget);
        expect(find.text('User'), findsOneWidget);
        expect(find.text('test@example.com'), findsOneWidget);
        expect(find.text('Log Out'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
      });
    });

    group('WidgetTree Auth State', () {
      testWidgets('shows HomePage when authenticated', (WidgetTester tester) async {
        final mockUser = MockUser(email: 'test@example.com');
        mockAuthService.setCurrentUser(mockUser);

        await tester.pumpWidget(createTestApp());
        await tester.pump();

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
      });

      testWidgets('shows LoginPage when not authenticated', (WidgetTester tester) async {
        mockAuthService.setCurrentUser(null);

        await tester.pumpWidget(createTestApp());
        await tester.pump();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(HomePage), findsNothing);
      });

      testWidgets('reacts to auth state changes', (WidgetTester tester) async {
        final mockUser = MockUser(email: 'test@example.com');
        mockAuthService.setCurrentUser(mockUser);

        await tester.pumpWidget(createTestApp());
        await tester.pump();

        expect(find.byType(HomePage), findsOneWidget);

        // Simulate logout
        mockAuthService.setCurrentUser(null);
        await tester.pump();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(HomePage), findsNothing);
      });
    });
  });
}