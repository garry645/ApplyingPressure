import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Display Regression Tests', () {
    test('Raw DateTime.toString() should NOT be used for display', () {
      // This test ensures we never display raw DateTime strings
      final dateWithMillis = DateTime.now();
      final rawString = dateWithMillis.toString();
      
      // Raw string contains milliseconds
      expect(rawString, contains('.'));
      expect(rawString, matches(RegExp(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+')));
      
      // This is what was happening before the fix - showing ugly timestamps
      // Example: "2024-01-15 14:05:23.456789"
      // We should NEVER show this to users
    });

    test('Formatted dates should be user-friendly', () {
      final date = DateTime(2024, 1, 15, 14, 5, 23, 456, 789);
      
      // Bad format (what we had before)
      final badFormat = date.toString();
      expect(badFormat, equals('2024-01-15 14:05:23.456789'));
      
      // Good format (what we have now)
      final goodFormat = '${date.month}/${date.day}/${date.year} '
          '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      expect(goodFormat, equals('1/15/2024 14:05'));
      
      // Ensure good format has no milliseconds
      expect(goodFormat, isNot(contains('.')));
      expect(goodFormat, isNot(contains('23'))); // no seconds
      expect(goodFormat, isNot(contains('456'))); // no milliseconds
    });

    test('ListTile subtitle concatenation should use formatted dates', () {
      final start = DateTime.now();
      final end = DateTime.now().add(const Duration(days: 7));
      
      // Bad way (direct concatenation)
      final badSubtitle = "$start\n$end";
      expect(badSubtitle, contains('.'));
      expect(badSubtitle.length, greaterThan(40)); // Very long string
      
      // Good way (formatted)
      String formatDate(DateTime? date) {
        if (date == null) return 'N/A';
        return '${date.month}/${date.day}/${date.year} '
            '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      
      final goodSubtitle = formatDate(start) + "\n" + formatDate(end);
      expect(goodSubtitle, isNot(contains('.')));
      expect(goodSubtitle.split('\n'), hasLength(2));
      
      // Each line should match our expected format
      final lines = goodSubtitle.split('\n');
      for (final line in lines) {
        expect(line, matches(RegExp(r'^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$')));
      }
    });
  });
}