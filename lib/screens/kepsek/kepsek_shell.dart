import 'package:material_ui/material_ui.dart';

import '../../repositories/kepsek_repository.dart';
import '../../repositories/mock_kepsek_repository.dart';
import '../../state/kepsek_controller.dart';
import '../../state/session_controller.dart';
import '../../widgets/role_scaffold.dart';
import 'kepsek_approval_screen.dart';
import 'kepsek_dashboard_screen.dart';
import 'kepsek_monitoring_screen.dart';
import 'kepsek_profile_screen.dart';

/// Halaman utama setelah login sebagai Kepala Sekolah.
///
/// Laporan akademik dan pengumuman tidak punya tab sendiri; keduanya dibuka
/// dari menu Profil (lihat `KepsekProfileScreen`).
class KepsekShell extends StatefulWidget {
  const KepsekShell({
    super.key,
    this.kepsekController,
    this.kepsekRepository,
  });

  /// Controller dari luar (untuk tes). Jika diisi, shell tidak men-dispose-nya.
  final KepsekController? kepsekController;
  final KepsekRepository? kepsekRepository;

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
    if (userId != null) _kepsek.bindKepsek(userId);
  }

  @override
  void dispose() {
    if (_ownsController) _kepsek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KepsekScope(
      controller: _kepsek,
      child: const RoleScaffold(
        tabs: [
          RoleTab(
            label: 'Beranda',
            icon: Icons.home_outlined,
            page: KepsekDashboardScreen(),
          ),
          RoleTab(
            label: 'Monitoring',
            icon: Icons.monitor_heart_outlined,
            page: KepsekMonitoringScreen(),
          ),
          RoleTab(
            label: 'Persetujuan',
            icon: Icons.fact_check_outlined,
            page: KepsekApprovalScreen(),
          ),
          RoleTab(
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            page: KepsekProfileScreen(),
          ),
        ],
      ),
    );
  }
}
