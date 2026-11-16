import 'package:material_ui/material_ui.dart';

import '../../repositories/guru_repository.dart';
import '../../repositories/mock_guru_repository.dart';
import '../../state/guru_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/lms_bottom_nav.dart';
import 'guru_attendance_screen.dart';
import 'guru_dashboard_screen.dart';
import 'guru_profile_screen.dart';
import 'guru_schedule_screen.dart';

class GuruShell extends StatefulWidget {
  const GuruShell({
    super.key,
    this.guruController,
    this.guruRepository,
  });

  /// Override untuk tes.
  final GuruController? guruController;
  final GuruRepository? guruRepository;

  static const _titles = ['Beranda', 'Jadwal', 'Absensi', 'Profil'];

  static const _destinations = [
    LmsDestination(label: 'Beranda', icon: Icons.home_outlined),
    LmsDestination(label: 'Jadwal', icon: Icons.calendar_month_outlined),
    LmsDestination(label: 'Absensi', icon: Icons.fact_check_outlined),
    LmsDestination(label: 'Profil', icon: Icons.person_outline_rounded),
  ];

  @override
  State<GuruShell> createState() => _GuruShellState();
}

class _GuruShellState extends State<GuruShell> {
  late final GuruController _guru;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.guruController == null;
    _guru = widget.guruController ??
        GuruController(
          repository: widget.guruRepository ??
              MockGuruRepository(),
        );
  }

  @override
  void dispose() {
    if (_ownsController) {
      _guru.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final index = session.tabIndex.clamp(0, GuruShell._titles.length - 1);

    return GuruScope(
      controller: _guru,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: LmsAppBar(title: GuruShell._titles[index]),
        body: IndexedStack(
          index: index,
          children: const [
            GuruDashboardScreen(),
            GuruScheduleScreen(),
            GuruAttendanceScreen(),
            GuruProfileScreen(),
          ],
        ),
        bottomNavigationBar: LmsBottomNav(
          index: index,
          destinations: GuruShell._destinations,
          onSelected: session.setTab,
        ),
      ),
    );
  }
}
