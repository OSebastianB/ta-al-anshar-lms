import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class LmsDestination {
  const LmsDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class LmsBottomNav extends StatelessWidget {
  const LmsBottomNav({
    super.key,
    required this.index,
    required this.destinations,
    required this.onSelected,
  });

  final int index;
  final List<LmsDestination> destinations;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onSelected,
        height: 68,
        backgroundColor: AppColors.card,
        surfaceTintColor: AppColors.card,
        indicatorColor: AppColors.accentSoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final item in destinations)
            NavigationDestination(
              icon: Icon(item.icon, color: AppColors.muted),
              selectedIcon: Icon(item.icon, color: AppColors.accent),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

NavigationBarThemeData lmsNavigationTheme() {
  return NavigationBarThemeData(
    height: 68,
    backgroundColor: AppColors.card,
    indicatorColor: AppColors.accentSoft,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return AppText.style(
        size: 12,
        weight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected ? AppColors.navy : AppColors.muted,
        height: 1.1,
      );
    }),
  );
}
