import 'dart:convert';

import '../../models/auth_session.dart';
import 'session_storage.dart';

/// Penyimpanan sesi di memori (cocok untuk tes & default aman tanpa plugin).
class MemorySessionStorage implements SessionStorage {
  AuthSession? _session;
  String? _rememberedUsername;

  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<AuthSession?> readSession() async => _session;

  @override
  Future<void> saveSession(AuthSession session) async {
    // Simpan salinan via JSON agar tidak memegang referensi mutable yang sama.
    _session = AuthSession.fromJson(
      jsonDecode(jsonEncode(session.toJson())) as Map<String, dynamic>,
    );
  }

  @override
  Future<String?> readRememberedUsername() async => _rememberedUsername;

  @override
  Future<void> saveRememberedUsername(String? username) async {
    _rememberedUsername = username?.trim().isEmpty == true
        ? null
        : username?.trim();
  }
}
