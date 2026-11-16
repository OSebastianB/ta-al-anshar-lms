import 'dart:convert';
import 'dart:math';

/// Generator token acak kryptografis (bukan timestamp tebak-tebakan).
abstract final class SecureToken {
  static final Random _rng = Random.secure();

  static String generate({int byteLength = 32}) {
    final bytes = List<int>.generate(byteLength, (_) => _rng.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
