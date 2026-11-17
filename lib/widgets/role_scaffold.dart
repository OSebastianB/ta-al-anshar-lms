import 'package:material_ui/material_ui.dart';

import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import 'lms_app_bar.dart';
import 'lms_bottom_nav.dart';

/// Satu tab pada bottom navigation sebuah role.
class RoleTab {
  const RoleTab({
    required this.label,
    required this.icon,
    required this.page,
  });

  /// Dipakai sebagai label bottom nav sekaligus judul app bar.
  final String label;
  final IconData icon;
  final Widget page;
}

/// Kerangka layar utama yang sama untuk semua role: app bar, isi tab,
/// dan bottom navigation.
///
/// Indeks tab disimpan di [SessionController.tabIndex] (bukan state lokal)
/// supaya kembali ke tab pertama setiap kali login/logout.
/// [IndexedStack] menjaga state tiap tab (scroll, form) saat berpindah tab.
class RoleScaffold extends StatelessWidget {
  const RoleScaffold({super.key, required this.tabs});

  final List<RoleTab> tabs;

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final index = session.tabIndex.clamp(0, tabs.length - 1);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: tabs[index].label),
      body: IndexedStack(
        index: index,
        children: [for (final tab in tabs) tab.page],
      ),
      bottomNavigationBar: LmsBottomNav(
        index: index,
        destinations: [
          for (final tab in tabs)
            LmsDestination(label: tab.label, icon: tab.icon),
        ],
        onSelected: session.setTab,
      ),
    );
  }
}
