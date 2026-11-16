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

  static const Duration mockNetworkDelay = Duration(milliseconds: 450);
}
