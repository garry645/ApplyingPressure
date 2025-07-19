import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/settings/settings_page.dart';
import 'package:applying_pressure/services/service_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../mocks/mock_auth_service.dart';
import '../mocks/mock_database_service.dart';
import '../mocks/mock_storage_service.dart';

void main() {
  group('Settings Page Tests', () {
    late MockAuthService mockAuthService;
    late MockDatabaseService mockDatabaseService;
    late MockStorageService mockStorageService;

    setUp(() {
      mockAuthService = MockAuthService();
      mockDatabaseService = MockDatabaseService();
      mockStorageService = MockStorageService();
      
      // Set up authenticated user
      final mockUser = MockUser(email: 'test@example.com');
      mockAuthService.setCurrentUser(mockUser);
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
          home: SettingsPage(),
        ),
      );
    }

    testWidgets('displays settings page UI correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Settings'), findsOneWidget); // App bar title
      expect(find.text('User Information'), findsOneWidget); // User section
      expect(find.text('User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget); // User email
      expect(find.text('Common'), findsOneWidget); // Common section title
      expect(find.text('Log Out'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('uses SettingsList widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SettingsList), findsOneWidget);
      expect(find.byType(SettingsSection), findsNWidgets(2)); // User Info + Common sections
      expect(find.byType(SettingsTile), findsNWidgets(2)); // User tile + Logout tile
    });

    testWidgets('logout tile is navigable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find the logout tile specifically (second SettingsTile)
      final logoutTile = tester.widgetList<SettingsTile>(find.byType(SettingsTile)).last;
      expect(logoutTile.onPressed, isNotNull);
    });

    testWidgets('shows user email when authenticated', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Not logged in'), findsNothing);
    });

    testWidgets('shows not logged in when user is null', (WidgetTester tester) async {
      // Set user to null
      mockAuthService.setCurrentUser(null);
      
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Not logged in'), findsOneWidget);
      expect(find.text('test@example.com'), findsNothing);
    });
  });
}