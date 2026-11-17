import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/auth_session.dart';
import 'session_storage.dart';

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const _sessionKey = 'auth.session.v1';
  static const _rememberKey = 'auth.remembered_username.v1';

  final FlutterSecureStorage _storage;

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }

  @override
  Future<AuthSession?> readSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final session = AuthSession.fromJson(json);
      if (session.isExpired) {
        await clearSession();
        return null;
      }
      return session;
    } on FormatException {
      await clearSession();
      return null;
    } on TypeError {
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    if (session.isExpired) {
      await clearSession();
      return;
    }
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  @override
  Future<String?> readRememberedUsername() async {
    final value = await _storage.read(key: _rememberKey);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  @override
  Future<void> saveRememberedUsername(String? username) async {
    final trimmed = username?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      await _storage.delete(key: _rememberKey);
      return;
    }
    await _storage.write(key: _rememberKey, value: trimmed);
  }
}
