import 'dart:convert';

import 'package:crypto/crypto.dart';

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

  static bool constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
