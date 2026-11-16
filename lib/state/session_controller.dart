import 'package:flutter/widgets.dart';

import '../core/config/app_config.dart';
import '../core/errors/auth_exception.dart';
import '../core/security/login_throttle.dart';
import '../models/app_role.dart';
import '../models/auth_session.dart';
import '../models/user_account.dart';
import '../services/auth_service.dart';

export '../models/app_role.dart';

class SessionController extends ChangeNotifier {
  SessionController({
    required this.authService,
    LoginThrottle? loginThrottle,
  }) : _throttle = loginThrottle ??
            LoginThrottle(
              maxAttempts: AppConfig.maxLoginAttempts,
              lockoutDuration: AppConfig.loginLockoutDuration,
            );

  final AuthService authService;
  final LoginThrottle _throttle;

  AuthSession? _session;
  int tabIndex = 0;
  bool isRestoring = true;
  bool isAuthenticating = false;
  String? lastError;

  AuthSession? get session => _session;
  UserAccount? get user => _session?.user;
  AppRole? get role => _session?.user.role;
  String? get accessToken => _session?.accessToken;
  bool get isLoggedIn => _session != null && !(_session?.isExpired ?? true);

  Future<void> bootstrap() async {
    isRestoring = true;
    lastError = null;
    notifyListeners();
    try {
      final restored = await authService.restoreSession();
      if (restored != null && restored.isExpired) {
        await authService.logout(restored);
        _session = null;
      } else {
        _session = restored;
      }
      tabIndex = 0;
    } finally {
      isRestoring = false;
      notifyListeners();
    }
  }

  Future<String?> rememberedUsername() {
    return authService.rememberedUsername();
  }

  Future<void> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    final trimmedUser = username.trim();
    if (trimmedUser.isEmpty || password.isEmpty) {
      lastError = 'Username dan password wajib diisi.';
      notifyListeners();
      throw AuthException(lastError!, code: 'validation');
    }

    final lockout = _throttle.remainingLockout(trimmedUser);
    if (lockout != null) {
      final seconds = lockout.inSeconds.clamp(1, 3600);
      lastError =
          'Terlalu banyak percobaan gagal. Coba lagi dalam $seconds detik.';
      notifyListeners();
      throw AuthException(lastError!, code: 'locked');
    }

    isAuthenticating = true;
    lastError = null;
    notifyListeners();

    try {
      _session = await authService.login(
        username: trimmedUser,
        password: password,
        rememberMe: rememberMe,
      );
      _throttle.recordSuccess(trimmedUser);
      tabIndex = 0;
      lastError = null;
    } on AuthException catch (error) {
      if (error.code == 'invalid_credentials' || error.code == 'validation') {
        _throttle.recordFailure(trimmedUser);
        final after = _throttle.remainingLockout(trimmedUser);
        if (after != null) {
          final seconds = after.inSeconds.clamp(1, 3600);
          lastError =
              'Terlalu banyak percobaan gagal. Coba lagi dalam $seconds detik.';
          throw AuthException(lastError!, code: 'locked');
        }
      }
      lastError = error.message;
      rethrow;
    } catch (error) {
      if (error is AuthException) rethrow;
      lastError = 'Gagal masuk. Periksa koneksi atau coba lagi.';
      throw AuthException(lastError!, code: 'unknown');
    } finally {
      isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final current = _session;
    isAuthenticating = true;
    notifyListeners();
    try {
      await authService.logout(current);
    } finally {
      _session = null;
      tabIndex = 0;
      lastError = null;
      isAuthenticating = false;
      notifyListeners();
    }
  }

  /// Paksa logout jika sesi kedaluwarsa saat aplikasi aktif.
  Future<void> ensureSessionValid() async {
    final current = _session;
    if (current == null) return;
    if (!current.isExpired) return;
    await logout();
  }

  void setTab(int index) {
    if (tabIndex == index) return;
    tabIndex = index;
    notifyListeners();
  }

  bool canAccess(AppRole requiredRole) => role == requiredRole;
}

class SessionScope extends InheritedNotifier<SessionController> {
  const SessionScope({
    super.key,
    required SessionController controller,
    required super.child,
  }) : super(notifier: controller);

  static SessionController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'SessionScope tidak ditemukan');
    return scope!.notifier!;
  }
}
