import 'dart:convert';

import 'package:doctor/components/urls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildBasicAuth', () {
    test('produces a valid, decodable Basic credential', () {
      final auth = buildBasicAuth('9998887776', 's3cret');

      expect(auth, startsWith('Basic '));

      final encoded = auth.substring('Basic '.length);
      final decoded = utf8.decode(base64.decode(encoded));
      expect(decoded, '9998887776:s3cret');
    });

    test('handles null credentials without throwing', () {
      final auth = buildBasicAuth(null, null);
      expect(auth, startsWith('Basic '));
      final decoded = utf8.decode(base64.decode(auth.substring(6)));
      expect(decoded, 'null:null');
    });
  });

  group('buildAuthHeaders', () {
    test('sets authorization and JSON content type', () {
      final headers = buildAuthHeaders('9998887776', 's3cret');

      expect(headers['authorization'], startsWith('Basic '));
      expect(headers['Content-Type'], contains('application/json'));
      // The header map must never leak the raw password.
      expect(headers.toString(), isNot(contains('s3cret')));
    });
  });
}
