/// Konfigurasi aplikasi. Nilai `fromEnvironment` diatur saat build/run,
/// contoh: `flutter run --dart-define=API_BASE_URL=https://...`.
abstract final class AppConfig {
  /// Base URL REST API. Default hanya placeholder sampai backend tersedia.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.alanshar.local/v1',
  );

  static const bool useMockAuth = bool.fromEnvironment(
    'USE_MOCK_AUTH',
    defaultValue: true,
  );

  /// Jika true, memilih akun demo di layar login ikut mengisi password.
  /// Biarkan false untuk build yang dibagikan ke pengguna.
  static const bool allowDemoPasswordPrefill = bool.fromEnvironment(
    'ALLOW_DEMO_PASSWORD_PREFILL',
    defaultValue: false,
  );

  /// Simulasi latensi jaringan pada repository mock.
  static const Duration mockNetworkDelay = Duration(milliseconds: 450);

  /// Lama sesi berlaku sebelum pengguna wajib login ulang.
  static const Duration sessionTtl = Duration(hours: 8);

  static const int maxLoginAttempts = 5;
  static const Duration loginLockoutDuration = Duration(minutes: 1);
}
