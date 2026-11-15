import 'package:material_ui/material_ui.dart';

import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/lms_bottom_nav.dart';
import 'kepsek_approval_screen.dart';
import 'kepsek_dashboard_screen.dart';
import 'kepsek_monitoring_screen.dart';
import 'kepsek_profile_screen.dart';

class KepsekShell extends StatelessWidget {
  const KepsekShell({super.key});

  static const _titles = ['Beranda', 'Monitoring', 'Persetujuan', 'Profil'];

  static const _destinations = [
    LmsDestination(label: 'Beranda', icon: Icons.home_outlined),
    LmsDestination(label: 'Monitoring', icon: Icons.monitor_heart_outlined),
    LmsDestination(label: 'Persetujuan', icon: Icons.fact_check_outlined),
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
          KepsekDashboardScreen(),
          KepsekMonitoringScreen(),
          KepsekApprovalScreen(),
          KepsekProfileScreen(),
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
