/// Centralized, environment-driven application configuration.
///
/// Values are provided at build/run time via `--dart-define`, e.g.:
///   flutter run --dart-define=API_BASE_URL=https://api.example.com/
///
/// A default is kept so existing builds keep working, but production builds
/// should always pass an explicit value.
class AppConfig {
  const AppConfig._();

  /// Base URL of the INCUE backend API. Must end with a trailing slash.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://incue-oep43kcksq-el.a.run.app/',
  );

  /// Default timeout applied to outbound HTTP requests.
  static const Duration httpTimeout = Duration(seconds: 30);
}
