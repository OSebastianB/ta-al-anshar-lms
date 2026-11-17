import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hash password untuk akun demo di `MockAuthRepository`.
///
/// Hanya untuk mode mock. Pada sistem produksi, password dikirim ke backend
/// melalui HTTPS dan diverifikasi di server (bcrypt/argon2 dengan salt unik);
/// aplikasi tidak boleh menyimpan hash password pengguna sungguhan.
abstract final class PasswordHasher {
  static const String _pepper = 'alanshar-lms-v1';

  static String hash({
    required String password,
    required String username,
  }) {
    final normalized = username.trim().toLowerCase();
    final material = '$_pepper|$normalized|$password';
    return sha256.convert(utf8.encode(material)).toString();
  }

  static bool verify({
    required String password,
    required String username,
    required String expectedHash,
  }) {
    final actual = hash(password: password, username: username);
    return constantTimeEquals(actual, expectedHash);
  }

  /// Membandingkan seluruh karakter tanpa berhenti di selisih pertama,
  /// supaya lama proses tidak membocorkan berapa karakter yang cocok.
  static bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
