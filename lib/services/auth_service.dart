import '../core/errors/auth_exception.dart';
import '../core/storage/session_storage.dart';
import '../models/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Orkestrasi autentikasi: repository + penyimpanan sesi.
/// Password tidak pernah ditulis ke storage.
class AuthService {
  AuthService({
    required this.repository,
    required this.sessionStorage,
  });

  final AuthRepository repository;
  final SessionStorage sessionStorage;

  Future<AuthSession> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final session = await repository.login(
      username: username,
      password: password,
    );

    await sessionStorage.saveSession(session);
    await sessionStorage.saveRememberedUsername(
      rememberMe ? username.trim() : null,
    );
    return session;
  }

  Future<AuthSession?> restoreSession() async {
    final stored = await sessionStorage.readSession();
    if (stored == null) return null;

    try {
      final validated = await repository.validateSession(stored);
      if (validated == null) {
        await sessionStorage.clearSession();
        return null;
      }
      return validated;
    } on AuthException {
      await sessionStorage.clearSession();
      return null;
    }
  }

  Future<void> logout(AuthSession? session) async {
    final token = session?.accessToken;
    if (token != null && token.isNotEmpty) {
      try {
        await repository.logout(accessToken: token);
      } on AuthException {
        // Tetap bersihkan sesi lokal meskipun server gagal dihubungi.
      }
    }
    await sessionStorage.clearSession();
  }

  Future<String?> rememberedUsername() {
    return sessionStorage.readRememberedUsername();
  }
}
