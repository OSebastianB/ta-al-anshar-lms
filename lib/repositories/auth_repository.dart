import '../models/auth_session.dart';

/// Kontrak autentikasi. UI/controller bergantung pada interface ini,
/// bukan pada mock atau HTTP secara langsung.
abstract class AuthRepository {
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  Future<void> logout({required String accessToken});

  /// Validasi/refresh sesi tersimpan. Kembalikan null jika tidak valid.
  Future<AuthSession?> validateSession(AuthSession session);
}
