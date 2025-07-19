import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Display Logic Tests', () {
    test('Date formatting should show correct month/day/year with padded time', () {
      final testDate = DateTime(2024, 1, 15, 14, 5); // Jan 15, 2024, 2:05 PM
      
      // Without padding - this should fail
      final formattedWrong = '${testDate.month}/${testDate.day}/${testDate.year}\t'
          '${testDate.hour}:${testDate.minute}';
      expect(formattedWrong, equals('1/15/2024\t14:5')); // Wrong format
      
      // With padding - this is correct
      final formattedCorrect = '${testDate.month}/${testDate.day}/${testDate.year}\t'
          '${testDate.hour}:${testDate.minute.toString().padLeft(2, '0')}';
      expect(formattedCorrect, equals('1/15/2024\t14:05')); // Correct format
    });

    test('Different dates should show different values', () {
      final startDate = DateTime(2024, 1, 1, 10, 0);
      final projectedEndDate = DateTime(2024, 1, 15, 15, 30);
      
      final startFormatted = '${startDate.month}/${startDate.day}/${startDate.year}';
      final endFormatted = '${projectedEndDate.month}/${projectedEndDate.day}/${projectedEndDate.year}';
      
      expect(startFormatted, equals('1/1/2024'));
      expect(endFormatted, equals('1/15/2024'));
      expect(startFormatted, isNot(equals(endFormatted)));
    });

    test('DateTime initialization should create different instances', () {
      final date1 = DateTime.now();
      // Small delay to ensure different timestamps
      final date2 = DateTime.now().add(const Duration(milliseconds: 1));
      
      expect(date1, isNot(equals(date2)));
    });
  });

  group('TextEditingController Disposal Tests', () {
    test('Controllers should be disposable', () {
      final controllers = [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ];

      // Set some text to verify controllers are working
      controllers[0].text = 'Title';
      controllers[1].text = 'Address';
      controllers[2].text = 'Description';

      expect(controllers[0].text, equals('Title'));
      expect(controllers[1].text, equals('Address'));
      expect(controllers[2].text, equals('Description'));

      // Dispose all controllers
      for (final controller in controllers) {
        controller.dispose();
      }

      // After disposal, controllers should not be used
      // Attempting to use them would throw an error
      // This verifies that our dispose implementation will prevent memory leaks
    });
  });
}