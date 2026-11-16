import '../core/config/app_config.dart';
import '../core/errors/auth_exception.dart';
import '../models/app_role.dart';
import '../models/auth_session.dart';
import '../models/user_account.dart';
import 'auth_repository.dart';

class _DemoAccount {
  const _DemoAccount({
    required this.username,
    required this.password,
    required this.user,
  });

  final String username;
  final String password;
  final UserAccount user;
}

/// Autentikasi mock untuk pengembangan tanpa backend.
/// Ganti ke implementasi API tanpa mengubah layar login.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.networkDelay = AppConfig.mockNetworkDelay,
  });

  final Duration networkDelay;

  static const List<_DemoAccount> _accounts = [
    _DemoAccount(
      username: 'ratna@alanshar.sch.id',
      password: 'demo',
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
      password: 'guru123',
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
      password: 'demo',
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
      password: 'demo',
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

  /// Akun demo yang ditampilkan sebagai bantuan di UI login.
  static ({String username, String password}) demoCredentialsFor(AppRole role) {
    final account = _accounts.firstWhere((item) => item.user.role == role);
    return (username: account.username, password: account.password);
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

    _DemoAccount? matched;
    for (final account in _accounts) {
      if (account.username.toLowerCase() == normalized &&
          account.password == password) {
        matched = account;
        break;
      }
    }

    if (matched == null) {
      throw const AuthException(
        'Username atau password salah.',
        code: 'invalid_credentials',
      );
    }

    final now = DateTime.now();
    return AuthSession(
      accessToken: 'mock-access-${matched.user.id}-${now.millisecondsSinceEpoch}',
      refreshToken: 'mock-refresh-${matched.user.id}',
      expiresAt: now.add(const Duration(hours: 8)),
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
    if (!session.accessToken.startsWith('mock-access-')) return null;
    return session;
  }
}
