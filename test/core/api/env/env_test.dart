import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/api/env/env.dart';

void main() {
  group('Env Configuration', () {
    test('baseUrl should be correctly loaded from environment', () {
      // Check that the value is not empty or null
      expect(Env.baseUrl, isNotNull);
      expect(Env.baseUrl, isNotEmpty);

      // Check for expected prefix/format to ensure obfuscation is decoding correctly
      expect(Env.baseUrl.startsWith('http'), isTrue);
    });

    test('baseUrl should match a specific pattern (optional)', () {
      // You can use a regex if you have different environments (prod/staging)
      final urlPattern = RegExp(r'^https?://[\w\-]+(\.[\w\-]+)+[/#?]?.*$');
      expect(urlPattern.hasMatch(Env.baseUrl), isTrue);
    });
  });
}
