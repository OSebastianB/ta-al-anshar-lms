import 'package:flutter/widgets.dart';

import '../core/errors/auth_exception.dart';
import '../models/app_role.dart';
import '../models/auth_session.dart';
import '../models/user_account.dart';
import '../services/auth_service.dart';

export '../models/app_role.dart';

class SessionController extends ChangeNotifier {
  SessionController({required this.authService});

  final AuthService authService;

  AuthSession? _session;
  int tabIndex = 0;
  bool isRestoring = true;
  bool isAuthenticating = false;
  String? lastError;

  AuthSession? get session => _session;
  UserAccount? get user => _session?.user;
  AppRole? get role => _session?.user.role;
  String? get accessToken => _session?.accessToken;
  bool get isLoggedIn => _session != null;

  Future<void> bootstrap() async {
    isRestoring = true;
    lastError = null;
    notifyListeners();
    try {
      _session = await authService.restoreSession();
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

    isAuthenticating = true;
    lastError = null;
    notifyListeners();

    try {
      _session = await authService.login(
        username: trimmedUser,
        password: password,
        rememberMe: rememberMe,
      );
      tabIndex = 0;
      lastError = null;
    } on AuthException catch (error) {
      lastError = error.message;
      rethrow;
    } catch (_) {
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
