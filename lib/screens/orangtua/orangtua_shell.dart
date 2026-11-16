import 'package:material_ui/material_ui.dart';

import '../../repositories/mock_parent_repository.dart';
import '../../repositories/parent_repository.dart';
import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/lms_bottom_nav.dart';
import 'orangtua_attendance_screen.dart';
import 'orangtua_dashboard_screen.dart';
import 'orangtua_profile_screen.dart';
import 'orangtua_schedule_screen.dart';

class OrangtuaShell extends StatefulWidget {
  const OrangtuaShell({
    super.key,
    this.parentController,
    this.parentRepository,
  });

  final ParentController? parentController;
  final ParentRepository? parentRepository;

  static const _titles = ['Beranda', 'Jadwal', 'Kehadiran', 'Profil'];

  static const _destinations = [
    LmsDestination(label: 'Beranda', icon: Icons.home_outlined),
    LmsDestination(label: 'Jadwal', icon: Icons.calendar_month_outlined),
    LmsDestination(label: 'Kehadiran', icon: Icons.how_to_reg_outlined),
    LmsDestination(label: 'Profil', icon: Icons.person_outline_rounded),
  ];

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
    if (userId != null) {
      _parent.bindParent(userId);
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _parent.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final index = session.tabIndex.clamp(0, OrangtuaShell._titles.length - 1);

    return ParentScope(
      controller: _parent,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: LmsAppBar(title: OrangtuaShell._titles[index]),
        body: IndexedStack(
          index: index,
          children: const [
            OrangtuaDashboardScreen(),
            OrangtuaScheduleScreen(),
            OrangtuaAttendanceScreen(),
            OrangtuaProfileScreen(),
          ],
        ),
        bottomNavigationBar: LmsBottomNav(
          index: index,
          destinations: OrangtuaShell._destinations,
          onSelected: session.setTab,
        ),
      ),
    );
  }
}
