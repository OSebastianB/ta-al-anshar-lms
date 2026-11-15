import 'package:material_ui/material_ui.dart';

import 'screens/guru/guru_shell.dart';
import 'screens/login/login_screen.dart';
import 'screens/orangtua/orangtua_shell.dart';
import 'state/session_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/lms_bottom_nav.dart';

class LmsApp extends StatefulWidget {
  const LmsApp({super.key});

  @override
  State<LmsApp> createState() => _LmsAppState();
}

class _LmsAppState extends State<LmsApp> {
  final _session = SessionController();

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      controller: _session,
      child: AnimatedBuilder(
        animation: _session,
        builder: (context, _) {
          final role = _session.role;
          return MaterialApp(
            title: 'LMS Al-Anshar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light().copyWith(
              navigationBarTheme: lmsNavigationTheme(),
            ),
            locale: const Locale('id'),
            supportedLocales: const [Locale('id'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: switch (role) {
              null => const LoginScreen(),
              AppRole.guru => const GuruShell(),
              AppRole.orangTua => const OrangtuaShell(),
            },
          );
        },
      ),
    );
  }
}
