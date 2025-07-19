import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/strings.dart';

void main() {
  group('Date Formatting Tests', () {
    test('Time should be padded with zeros for single digit minutes', () {
      final date = DateTime(2024, 1, 15, 14, 5); // 2:05 PM
      final formatted = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('14:05'));
      expect(formatted, isNot(equals('14:5')));
    });

    test('Time should not pad double digit minutes', () {
      final date = DateTime(2024, 1, 15, 14, 30); // 2:30 PM
      final formatted = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('14:30'));
    });

    test('DateTime.now() includes milliseconds', () {
      final now = DateTime.now();
      
      // DateTime.now() should have non-zero microseconds
      expect(now.microsecond, isNot(equals(0)));
      
      // String representation includes milliseconds
      final stringRep = now.toString();
      expect(stringRep, contains('.'));
    });

    test('Clean DateTime should not have milliseconds', () {
      final now = DateTime.now();
      final clean = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      
      expect(clean.second, equals(0));
      expect(clean.millisecond, equals(0));
      expect(clean.microsecond, equals(0));
      
      // String representation should not include decimal
      final stringRep = clean.toString();
      expect(stringRep, endsWith(':00.000'));
    });

    test('Format date helper should handle null dates', () {
      String formatDate(DateTime? date) {
        if (date == null) return naString;
        return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      
      expect(formatDate(null), equals(naString));
      expect(formatDate(DateTime(2024, 1, 1, 9, 5)), equals('1/1/2024 9:05'));
    });

    test('Full date format should be clean and readable', () {
      final date = DateTime(2024, 12, 25, 15, 7); // Dec 25, 2024, 3:07 PM
      final formatted = '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('12/25/2024 15:07'));
    });

    test('Midnight should format correctly', () {
      final midnight = DateTime(2024, 1, 1, 0, 0);
      final formatted = '${midnight.hour.toString().padLeft(2, '0')}:${midnight.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('00:00'));
    });

    test('Noon should format correctly', () {
      final noon = DateTime(2024, 1, 1, 12, 0);
      final formatted = '${noon.hour.toString().padLeft(2, '0')}:${noon.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('12:00'));
    });

    test('Early morning hours should be padded', () {
      final earlyMorning = DateTime(2024, 1, 1, 1, 30);
      final formatted = '${earlyMorning.hour.toString().padLeft(2, '0')}:${earlyMorning.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('01:30'));
    });

    test('Single digit hour should be padded', () {
      final singleDigit = DateTime(2024, 1, 1, 9, 5);
      final formatted = '${singleDigit.hour.toString().padLeft(2, '0')}:${singleDigit.minute.toString().padLeft(2, '0')}';
      
      expect(formatted, equals('09:05'));
    });
  });

  group('Date Comparison Tests', () {
    test('Dates with different milliseconds should be different', () {
      final date1 = DateTime(2024, 1, 1, 12, 0, 0, 100); // 100 milliseconds
      final date2 = DateTime(2024, 1, 1, 12, 0, 0, 200); // 200 milliseconds
      
      // Different milliseconds should make dates unequal
      expect(date1, isNot(equals(date2)));
      
      // But when comparing just the time parts we care about, they're the same
      expect(date1.hour, equals(date2.hour));
      expect(date1.minute, equals(date2.minute));
    });

    test('Cleaned dates from same source should be equal', () {
      final now = DateTime.now();
      final clean1 = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      final clean2 = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      
      expect(clean1, equals(clean2));
    });
  });
}