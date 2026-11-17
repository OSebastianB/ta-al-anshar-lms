import 'dart:convert';
import 'dart:math';

/// Token acak dari `Random.secure` (CSPRNG), dipakai untuk token sesi mock.
/// Saat backend tersedia, token berasal dari server dan kelas ini tidak dipakai.
abstract final class SecureToken {
  static final Random _rng = Random.secure();

  static String generate({int byteLength = 32}) {
    final bytes = List<int>.generate(byteLength, (_) => _rng.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
