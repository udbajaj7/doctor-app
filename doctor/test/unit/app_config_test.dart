import 'package:doctor/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('exposes a base URL that ends with a slash', () {
      expect(AppConfig.apiBaseUrl, isNotEmpty);
      expect(AppConfig.apiBaseUrl.endsWith('/'), isTrue,
          reason: 'endpoints are concatenated onto the base URL');
    });

    test('defines a positive HTTP timeout', () {
      expect(AppConfig.httpTimeout, greaterThan(Duration.zero));
    });
  });
}
