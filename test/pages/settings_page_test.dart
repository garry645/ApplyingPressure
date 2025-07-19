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
      expect(find.text('Common'), findsOneWidget); // Section title
      expect(find.text('Log Out'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('uses SettingsList widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SettingsList), findsOneWidget);
      expect(find.byType(SettingsSection), findsOneWidget);
      expect(find.byType(SettingsTile), findsOneWidget);
    });

    testWidgets('logout tile is navigable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final logoutTile = tester.widget<SettingsTile>(find.byType(SettingsTile));
      expect(logoutTile.onPressed, isNotNull);
    });
  });
}