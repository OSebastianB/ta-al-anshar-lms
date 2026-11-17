import 'dart:math';

import '../core/config/app_config.dart';
import '../core/errors/auth_exception.dart';
import '../core/security/password_hasher.dart';
import '../core/security/secure_token.dart';
import '../models/app_role.dart';
import '../models/auth_session.dart';
import '../models/user_account.dart';
import 'auth_repository.dart';

class _DemoAccount {
  const _DemoAccount({
    required this.username,
    required this.passwordHash,
    required this.user,
  });

  final String username;
  final String passwordHash;
  final UserAccount user;
}

/// Autentikasi mock (tanpa backend). Password disimpan sebagai hash.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.networkDelay = AppConfig.mockNetworkDelay,
  });

  final Duration networkDelay;

  static const List<_DemoAccount> _accounts = [
    _DemoAccount(
      username: 'ratna@alanshar.sch.id',
      passwordHash:
          'ba180b55b71f673137480c03333fbf5f2cf2cc3f9d754eac4ef4066c21a8ab92',
      user: UserAccount(
        id: 'usr-guru-001',
        name: 'Bu Ratna Sari',
        email: 'ratna@alanshar.sch.id',
        role: AppRole.guru,
        initials: 'RS',
        roleLabel: 'Guru Kelas · Wali Kelas VA',
        phone: '0812-3456-7890',
      ),
    ),
    _DemoAccount(
      username: 'guru@alanshar.sch.id',
      passwordHash:
          '301d096808ddbb292c28c37a1b37ab61fdd13f58b90a398e97c5966be7ea291c',
      user: UserAccount(
        id: 'usr-guru-001',
        name: 'Bu Ratna Sari',
        email: 'ratna@alanshar.sch.id',
        role: AppRole.guru,
        initials: 'RS',
        roleLabel: 'Guru Kelas · Wali Kelas VA',
        phone: '0812-3456-7890',
      ),
    ),
    _DemoAccount(
      username: 'ortu@alanshar.sch.id',
      passwordHash:
          '6e02de0b38f235118cb1c42a29ba1d4278ce3558de2a32aa070e7469841401df',
      user: UserAccount(
        id: 'usr-ortu-001',
        name: 'Ibu Siti Ramadhani',
        email: 'ortu@alanshar.sch.id',
        role: AppRole.orangTua,
        initials: 'SR',
        roleLabel: 'Orang Tua / Wali Murid',
        phone: '0813-9876-5432',
      ),
    ),
    _DemoAccount(
      username: 'kepsek@alanshar.sch.id',
      passwordHash:
          'ff560fb57b7b52682a1bbee7dcd879bedf840967b0c8c1f7cfb40f4223227ea2',
      user: UserAccount(
        id: 'usr-kepsek-001',
        name: 'Pak Hidayat Rahman',
        email: 'kepsek@alanshar.sch.id',
        role: AppRole.kepalaSekolah,
        initials: 'HR',
        roleLabel: 'Kepala Sekolah',
        phone: '0811-2233-4455',
      ),
    ),
  ];

  static String demoUsernameFor(AppRole role) {
    final account = _accounts.firstWhere((item) => item.user.role == role);
    return account.username;
  }

  static String? demoPasswordHintFor(AppRole role) {
    if (!AppConfig.allowDemoPasswordPrefill) return null;
    return switch (role) {
      AppRole.guru => 'demo',
      AppRole.orangTua => 'demo',
      AppRole.kepalaSekolah => 'demo',
    };
  }

  static List<({AppRole role, String username})> get demoDirectory {
    final seen = <AppRole>{};
    final result = <({AppRole role, String username})>[];
    for (final account in _accounts) {
      if (seen.add(account.user.role)) {
        result.add((role: account.user.role, username: account.username));
      }
    }
    return result;
  }

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(networkDelay);

    final normalized = username.trim().toLowerCase();
    if (normalized.isEmpty || password.isEmpty) {
      throw const AuthException(
        'Username dan password wajib diisi.',
        code: 'validation',
      );
    }

    if (password.length < 4) {
      throw const AuthException(
        'Password minimal 4 karakter.',
        code: 'validation',
      );
    }

    await Future<void>.delayed(
      Duration(milliseconds: 40 + Random.secure().nextInt(80)),
    );

    _DemoAccount? matched;
    for (final account in _accounts) {
      if (account.username.toLowerCase() != normalized) continue;
      if (PasswordHasher.verify(
        password: password,
        username: account.username,
        expectedHash: account.passwordHash,
      )) {
        matched = account;
      }
      break;
    }

    if (matched == null) {
      throw const AuthException(
        'Username atau password salah.',
        code: 'invalid_credentials',
      );
    }

    final now = DateTime.now();
    final access = SecureToken.generate();
    final refresh = SecureToken.generate(byteLength: 24);
    return AuthSession(
      accessToken: 'mock.$access',
      refreshToken: 'mock.$refresh',
      expiresAt: now.add(AppConfig.sessionTtl),
      user: matched.user,
    );
  }

  @override
  Future<void> logout({required String accessToken}) async {
    await Future<void>.delayed(
      networkDelay > Duration.zero
          ? const Duration(milliseconds: 120)
          : Duration.zero,
    );
    // Mock: token dibuang di sisi klien melalui SessionStorage.
  }

  @override
  Future<AuthSession?> validateSession(AuthSession session) async {
    await Future<void>.delayed(
      networkDelay > Duration.zero
          ? const Duration(milliseconds: 80)
          : Duration.zero,
    );
    if (session.isExpired) return null;
    if (!session.accessToken.startsWith('mock.')) return null;
    if (session.accessToken.length < 20) return null;
    return session;
  }
}
