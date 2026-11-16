import 'user_account.dart';

/// Sesi autentikasi (token + profil). Password tidak pernah disimpan di sini.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.user,
    required this.expiresAt,
    this.refreshToken,
  });

  final String accessToken;
  final String? refreshToken;
  final UserAccount user;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: UserAccount.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
