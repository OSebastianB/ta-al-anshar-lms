import 'package:material_ui/material_ui.dart';

import 'core/storage/secure_session_storage.dart';
import 'core/storage/session_storage.dart';
import 'repositories/auth_repository.dart';
import 'repositories/guru_repository.dart';
import 'repositories/kepsek_repository.dart';
import 'repositories/mock_auth_repository.dart';
import 'repositories/parent_repository.dart';
import 'screens/guru/guru_shell.dart';
import 'screens/kepsek/kepsek_shell.dart';
import 'screens/login/login_screen.dart';
import 'screens/orangtua/orangtua_shell.dart';
import 'services/auth_service.dart';
import 'state/session_controller.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'widgets/lms_bottom_nav.dart';

/// Root aplikasi sekaligus tempat merakit dependensi (composition root).
///
/// Semua repository bisa diganti lewat konstruktor. Tes memakai mock tanpa
/// delay; nanti implementasi API dimasukkan di sini tanpa menyentuh layar.
/// Parameter yang tidak diisi memakai implementasi mock/default.
class LmsApp extends StatefulWidget {
  const LmsApp({
    super.key,
    this.authRepository,
    this.sessionStorage,
    this.guruRepository,
    this.parentRepository,
    this.kepsekRepository,
  });

  final AuthRepository? authRepository;
  final SessionStorage? sessionStorage;
  final GuruRepository? guruRepository;
  final ParentRepository? parentRepository;
  final KepsekRepository? kepsekRepository;

  @override
  State<LmsApp> createState() => _LmsAppState();
}

class _LmsAppState extends State<LmsApp> {
  late final SessionController _session;

  @override
  void initState() {
    super.initState();
    final repository = widget.authRepository ?? MockAuthRepository();
    final storage = widget.sessionStorage ?? SecureSessionStorage();
    _session = SessionController(
      authService: AuthService(
        repository: repository,
        sessionStorage: storage,
      ),
    );
    _session.bootstrap();
  }

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      controller: _session,
      child: MaterialApp(
        title: 'LMS Al-Anshar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light().copyWith(
          navigationBarTheme: lmsNavigationTheme(),
        ),
        locale: const Locale('id'),
        supportedLocales: const [Locale('id'), Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Menentukan layar yang tampil dari status sesi:
/// memulihkan sesi -> loading, belum login -> [LoginScreen],
/// sudah login -> shell sesuai role akun.
///
/// Berada di dalam [MaterialApp] sehingga pergantian role/tab tidak
/// membuat ulang MaterialApp (tema dan navigator tetap).
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);

    if (session.isRestoring) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final role = session.role;
    if (role == null || !session.isLoggedIn) {
      return const LoginScreen();
    }

    final app = context.findAncestorWidgetOfExactType<LmsApp>();
    return switch (role) {
      AppRole.guru => GuruShell(guruRepository: app?.guruRepository),
      AppRole.orangTua =>
          OrangtuaShell(parentRepository: app?.parentRepository),
      AppRole.kepalaSekolah =>
          KepsekShell(kepsekRepository: app?.kepsekRepository),
    };
  }
}
