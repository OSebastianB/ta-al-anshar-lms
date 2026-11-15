import 'package:material_ui/material_ui.dart';

import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/lms_bottom_nav.dart';
import 'orangtua_attendance_screen.dart';
import 'orangtua_dashboard_screen.dart';
import 'orangtua_profile_screen.dart';
import 'orangtua_schedule_screen.dart';

class OrangtuaShell extends StatelessWidget {
  const OrangtuaShell({super.key});

  static const _titles = ['Beranda', 'Jadwal', 'Kehadiran', 'Profil'];

  static const _destinations = [
    LmsDestination(label: 'Beranda', icon: Icons.home_outlined),
    LmsDestination(label: 'Jadwal', icon: Icons.calendar_month_outlined),
    LmsDestination(label: 'Kehadiran', icon: Icons.how_to_reg_outlined),
    LmsDestination(label: 'Profil', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final index = session.tabIndex.clamp(0, _titles.length - 1);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: _titles[index]),
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
        destinations: _destinations,
        onSelected: session.setTab,
      ),
    );
  }
}
