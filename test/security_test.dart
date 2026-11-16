import 'package:al_anshar_lms/core/security/login_throttle.dart';
import 'package:al_anshar_lms/core/security/password_hasher.dart';
import 'package:al_anshar_lms/core/security/secure_token.dart';
import 'package:al_anshar_lms/core/storage/memory_session_storage.dart';
import 'package:al_anshar_lms/models/auth_session.dart';
import 'package:al_anshar_lms/models/user_account.dart';
import 'package:al_anshar_lms/repositories/mock_auth_repository.dart';
import 'package:al_anshar_lms/services/auth_service.dart';
import 'package:al_anshar_lms/state/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordHasher', () {
    test('hash konsisten dan verifikasi berhasil', () {
      const user = 'ratna@alanshar.sch.id';
      const pass = 'demo';
      final hash = PasswordHasher.hash(password: pass, username: user);
      expect(
        hash,
        'ba180b55b71f673137480c03333fbf5f2cf2cc3f9d754eac4ef4066c21a8ab92',
      );
      expect(
        PasswordHasher.verify(
          password: pass,
          username: user,
          expectedHash: hash,
        ),
        isTrue,
      );
      expect(
        PasswordHasher.verify(
          password: 'salah',
          username: user,
          expectedHash: hash,
        ),
        isFalse,
      );
    });

    test('constantTimeEquals menolak panjang berbeda', () {
      expect(PasswordHasher.constantTimeEquals('abc', 'ab'), isFalse);
      expect(PasswordHasher.constantTimeEquals('abc', 'abc'), isTrue);
    });
  });

  group('SecureToken', () {
    test('menghasilkan token unik yang cukup panjang', () {
      final a = SecureToken.generate();
      final b = SecureToken.generate();
      expect(a, isNot(equals(b)));
      expect(a.length, greaterThanOrEqualTo(32));
    });
  });

  group('LoginThrottle', () {
    test('mengunci setelah maxAttempts gagal', () {
      final throttle = LoginThrottle(
        maxAttempts: 3,
        lockoutDuration: const Duration(minutes: 1),
      );
      const user = 'tester@alanshar.sch.id';

      throttle.recordFailure(user);
      throttle.recordFailure(user);
      expect(throttle.isLocked(user), isFalse);

      throttle.recordFailure(user);
      expect(throttle.isLocked(user), isTrue);
      expect(throttle.remainingLockout(user), isNotNull);

      throttle.recordSuccess(user);
      expect(throttle.isLocked(user), isFalse);
    });
  });

  group('MockAuthRepository security', () {
    test('login berhasil dengan password benar (hash)', () async {
      final repo = MockAuthRepository(networkDelay: Duration.zero);
      final session = await repo.login(
        username: 'ratna@alanshar.sch.id',
        password: 'demo',
      );
      expect(session.user.role, AppRole.guru);
      expect(session.accessToken.startsWith('mock.'), isTrue);
      expect(session.isExpired, isFalse);
    });

    test('login gagal tidak membocorkan apakah user ada', () async {
      final repo = MockAuthRepository(networkDelay: Duration.zero);
      await expectLater(
        repo.login(username: 'tidakada@alanshar.sch.id', password: 'demo'),
        throwsA(
          predicate(
            (error) =>
                error.toString().contains('Username atau password salah.'),
          ),
        ),
      );
    });

    test('sesi kedaluwarsa ditolak validateSession', () async {
      final repo = MockAuthRepository(networkDelay: Duration.zero);
      final expired = AuthSession(
        accessToken: 'mock.expiredtokenvalue123456',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        user: const UserAccount(
          id: 'x',
          name: 'X',
          email: 'x@alanshar.sch.id',
          role: AppRole.guru,
          initials: 'X',
          roleLabel: 'Guru',
        ),
      );
      expect(await repo.validateSession(expired), isNull);
    });
  });

  group('SessionController lockout', () {
    test('mengunci setelah beberapa login gagal', () async {
      final controller = SessionController(
        authService: AuthService(
          repository: MockAuthRepository(networkDelay: Duration.zero),
          sessionStorage: MemorySessionStorage(),
        ),
        loginThrottle: LoginThrottle(
          maxAttempts: 2,
          lockoutDuration: const Duration(minutes: 5),
        ),
      );

      await expectLater(
        controller.login(username: 'ratna@alanshar.sch.id', password: 'salah'),
        throwsA(isA<Object>()),
      );
      await expectLater(
        controller.login(username: 'ratna@alanshar.sch.id', password: 'salah'),
        throwsA(isA<Object>()),
      );
      expect(controller.lastError, contains('Terlalu banyak percobaan'));
    });
  });
}
