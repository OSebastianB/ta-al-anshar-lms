import 'package:material_ui/material_ui.dart';

import '../../repositories/kepsek_repository.dart';
import '../../repositories/mock_kepsek_repository.dart';
import '../../state/kepsek_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/lms_bottom_nav.dart';
import 'kepsek_approval_screen.dart';
import 'kepsek_dashboard_screen.dart';
import 'kepsek_monitoring_screen.dart';
import 'kepsek_profile_screen.dart';

class KepsekShell extends StatefulWidget {
  const KepsekShell({
    super.key,
    this.kepsekController,
    this.kepsekRepository,
  });

  final KepsekController? kepsekController;
  final KepsekRepository? kepsekRepository;

  static const _titles = ['Beranda', 'Monitoring', 'Persetujuan', 'Profil'];

  static const _destinations = [
    LmsDestination(label: 'Beranda', icon: Icons.home_outlined),
    LmsDestination(label: 'Monitoring', icon: Icons.monitor_heart_outlined),
    LmsDestination(label: 'Persetujuan', icon: Icons.fact_check_outlined),
    LmsDestination(label: 'Profil', icon: Icons.person_outline_rounded),
  ];

  @override
  State<KepsekShell> createState() => _KepsekShellState();
}

class _KepsekShellState extends State<KepsekShell> {
  late final KepsekController _kepsek;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.kepsekController == null;
    _kepsek = widget.kepsekController ??
        KepsekController(
          repository: widget.kepsekRepository ?? MockKepsekRepository(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = SessionScope.of(context).user?.id;
    if (userId != null) {
      _kepsek.bindKepsek(userId);
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _kepsek.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final index = session.tabIndex.clamp(0, KepsekShell._titles.length - 1);

    return KepsekScope(
      controller: _kepsek,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: LmsAppBar(title: KepsekShell._titles[index]),
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
          destinations: KepsekShell._destinations,
          onSelected: session.setTab,
        ),
      ),
    );
  }
}
