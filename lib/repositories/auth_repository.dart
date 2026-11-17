import '../models/auth_session.dart';

/// Kontrak autentikasi. UI/controller bergantung pada interface ini,
/// bukan pada mock atau HTTP secara langsung.
///
/// Role pengguna diambil dari [AuthSession.user] hasil login, bukan dari
/// pilihan di layar login, sehingga backend yang menentukan hak akses.
abstract class AuthRepository {
  /// Lempar `AuthException` dengan kode `invalid_credentials` bila salah,
  /// atau `validation` bila input tidak memenuhi syarat. Kedua kode ini
  /// dihitung sebagai percobaan gagal oleh pembatas login.
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  Future<void> logout({required String accessToken});

  /// Validasi/refresh sesi tersimpan. Kembalikan null jika tidak valid.
  Future<AuthSession?> validateSession(AuthSession session);
}
