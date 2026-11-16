import '../../models/auth_session.dart';

/// Penyimpanan sesi. Password tidak boleh disimpan di implementasi mana pun.
abstract class SessionStorage {
  Future<void> saveSession(AuthSession session);

  Future<AuthSession?> readSession();

  Future<void> clearSession();

  Future<void> saveRememberedUsername(String? username);

  Future<String?> readRememberedUsername();
}
