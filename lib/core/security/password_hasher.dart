import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hash password sisi klien untuk mock/local.
/// Produksi: hashing & verifikasi harus di server (bcrypt/argon2 + salt unik).
abstract final class PasswordHasher {
  /// Pepper aplikasi — diganti kontrak server saat API tersedia.
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

  /// Bandingkan string tanpa early-return agar sulit di-timing attack.
  static bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
