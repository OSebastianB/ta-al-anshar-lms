abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.alanshar.local/v1',
  );

  static const bool useMockAuth = bool.fromEnvironment(
    'USE_MOCK_AUTH',
    defaultValue: true,
  );

  static const bool allowDemoPasswordPrefill = bool.fromEnvironment(
    'ALLOW_DEMO_PASSWORD_PREFILL',
    defaultValue: false,
  );

  static const Duration mockNetworkDelay = Duration(milliseconds: 450);
  static const Duration sessionTtl = Duration(hours: 8);
  static const int maxLoginAttempts = 5;
  static const Duration loginLockoutDuration = Duration(minutes: 1);
}
