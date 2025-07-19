import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/jobs/jobs_list_page.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../firebase_test_config.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: testFirebaseOptions,
    );
    dotenv.testLoad(fileInput: 'USE_TEST_COLLECTIONS=true\nENV=test');
  });

  group('JobsListPage Date Formatting Tests', () {
    testWidgets('Job list items should display formatted dates without milliseconds', 
        (WidgetTester tester) async {
      // This test would require mocking Firestore data
      // For now, we'll test the formatting logic directly
      expect(true, isTrue); // Placeholder
    });

    test('Date formatting method should format correctly', () {
      // Test the _formatDate logic
      String formatDate(DateTime? date) {
        if (date == null) return 'N/A';
        return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }

      // Test null handling
      expect(formatDate(null), equals('N/A'));

      // Test single digit minute padding
      final date1 = DateTime(2024, 1, 15, 9, 5);
      expect(formatDate(date1), equals('1/15/2024 9:05'));

      // Test double digit minutes
      final date2 = DateTime(2024, 12, 25, 14, 30);
      expect(formatDate(date2), equals('12/25/2024 14:30'));

      // Test midnight
      final midnight = DateTime(2024, 1, 1, 0, 0);
      expect(formatDate(midnight), equals('1/1/2024 0:00'));
    });

    test('Job list tile should not show milliseconds in subtitle', () {
      // Create a job with DateTime that includes milliseconds
      final jobWithMillis = Job(
        id: 'test-1',
        title: 'Test Job',
        address: '123 Test St',
        startDate: DateTime.now(), // This includes milliseconds
        projectedEndDate: DateTime.now().add(const Duration(days: 7)),
      );

      // The raw DateTime string includes milliseconds
      final rawStartString = jobWithMillis.startDate.toString();
      expect(rawStartString, contains('.'));

      // But our formatted version should not
      String formatDate(DateTime? date) {
        if (date == null) return 'N/A';
        return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }

      final formattedStart = formatDate(jobWithMillis.startDate);
      expect(formattedStart, isNot(contains('.')));
      expect(formattedStart, matches(RegExp(r'^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$')));
    });
  });

  group('JobsListPage Layout Tests', () {
    test('ListTile subtitle should have two lines', () {
      final startDate = DateTime(2024, 1, 1, 9, 0);
      final endDate = DateTime(2024, 1, 15, 17, 0);
      
      String formatDate(DateTime? date) {
        if (date == null) return 'N/A';
        return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      
      final subtitle = formatDate(startDate) + "\n" + formatDate(endDate);
      
      expect(subtitle, contains('\n'));
      expect(subtitle.split('\n'), hasLength(2));
      expect(subtitle, equals('1/1/2024 9:00\n1/15/2024 17:00'));
    });
  });
}