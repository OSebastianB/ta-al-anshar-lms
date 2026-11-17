import 'package:material_ui/material_ui.dart';

import '../../repositories/guru_repository.dart';
import '../../repositories/mock_guru_repository.dart';
import '../../state/guru_controller.dart';
import '../../widgets/role_scaffold.dart';
import 'guru_attendance_screen.dart';
import 'guru_dashboard_screen.dart';
import 'guru_profile_screen.dart';
import 'guru_schedule_screen.dart';

/// Halaman utama setelah login sebagai Guru.
///
/// Membuat [GuruController] sekali untuk seluruh tab. Saat backend siap,
/// cukup kirim implementasi API lewat [guruRepository] (lihat `LmsApp`).
class GuruShell extends StatefulWidget {
  const GuruShell({
    super.key,
    this.guruController,
    this.guruRepository,
  });

  /// Controller dari luar (untuk tes). Jika diisi, shell tidak men-dispose-nya.
  final GuruController? guruController;
  final GuruRepository? guruRepository;

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
          repository: widget.guruRepository ?? MockGuruRepository(),
        );
  }

  @override
  void dispose() {
    if (_ownsController) _guru.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GuruScope(
      controller: _guru,
      child: const RoleScaffold(
        tabs: [
          RoleTab(
            label: 'Beranda',
            icon: Icons.home_outlined,
            page: GuruDashboardScreen(),
          ),
          RoleTab(
            label: 'Jadwal',
            icon: Icons.calendar_month_outlined,
            page: GuruScheduleScreen(),
          ),
          RoleTab(
            label: 'Absensi',
            icon: Icons.fact_check_outlined,
            page: GuruAttendanceScreen(),
          ),
          RoleTab(
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            page: GuruProfileScreen(),
          ),
        ],
      ),
    );
  }
}
