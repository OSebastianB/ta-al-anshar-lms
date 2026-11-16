/// Konfigurasi aplikasi.
/// Base URL diganti lewat `--dart-define=API_BASE_URL=...` saat build/run.
/// Jangan anggap nilai default sebagai endpoint produksi final.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.alanshar.local/v1',
  );

  /// Selama backend belum tersedia, autentikasi memakai mock repository.
  static const bool useMockAuth = bool.fromEnvironment(
    'USE_MOCK_AUTH',
    defaultValue: true,
  );

  /// Prefill password demo di UI login (default OFF — lebih aman).
  /// Aktifkan hanya untuk demo: `--dart-define=ALLOW_DEMO_PASSWORD_PREFILL=true`.
  static const bool allowDemoPasswordPrefill = bool.fromEnvironment(
    'ALLOW_DEMO_PASSWORD_PREFILL',
    defaultValue: false,
  );

  static const Duration mockNetworkDelay = Duration(milliseconds: 450);

  /// Umur sesi lokal sebelum wajib login ulang.
  static const Duration sessionTtl = Duration(hours: 8);

  /// Batas gagal login sebelum lockout lokal.
  static const int maxLoginAttempts = 5;

  static const Duration loginLockoutDuration = Duration(minutes: 1);
}
