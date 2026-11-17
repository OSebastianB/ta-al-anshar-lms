import 'package:material_ui/material_ui.dart';

import '../../repositories/mock_parent_repository.dart';
import '../../repositories/parent_repository.dart';
import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
import '../../widgets/role_scaffold.dart';
import 'orangtua_attendance_screen.dart';
import 'orangtua_dashboard_screen.dart';
import 'orangtua_profile_screen.dart';
import 'orangtua_schedule_screen.dart';

/// Halaman utama setelah login sebagai Orang Tua.
///
/// [ParentController] diikat ke user yang login di [didChangeDependencies]
/// agar semua data yang dimuat hanya milik anak dari akun tersebut.
class OrangtuaShell extends StatefulWidget {
  const OrangtuaShell({
    super.key,
    this.parentController,
    this.parentRepository,
  });

  /// Controller dari luar (untuk tes). Jika diisi, shell tidak men-dispose-nya.
  final ParentController? parentController;
  final ParentRepository? parentRepository;

  @override
  State<OrangtuaShell> createState() => _OrangtuaShellState();
}

class _OrangtuaShellState extends State<OrangtuaShell> {
  late final ParentController _parent;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.parentController == null;
    _parent = widget.parentController ??
        ParentController(
          repository: widget.parentRepository ?? MockParentRepository(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = SessionScope.of(context).user?.id;
    if (userId != null) _parent.bindParent(userId);
  }

  @override
  void dispose() {
    if (_ownsController) _parent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParentScope(
      controller: _parent,
      child: const RoleScaffold(
        tabs: [
          RoleTab(
            label: 'Beranda',
            icon: Icons.home_outlined,
            page: OrangtuaDashboardScreen(),
          ),
          RoleTab(
            label: 'Jadwal',
            icon: Icons.calendar_month_outlined,
            page: OrangtuaScheduleScreen(),
          ),
          RoleTab(
            label: 'Kehadiran',
            icon: Icons.how_to_reg_outlined,
            page: OrangtuaAttendanceScreen(),
          ),
          RoleTab(
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            page: OrangtuaProfileScreen(),
          ),
        ],
      ),
    );
  }
}
