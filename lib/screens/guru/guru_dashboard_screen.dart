import 'package:material_ui/material_ui.dart';

import '../../state/guru_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/schedule_card.dart';
import '../../widgets/shortcut_tile.dart';
import '../../widgets/summary_card.dart';
import 'guru_attendance_history_screen.dart';
import 'guru_classes_screen.dart';

class GuruDashboardScreen extends StatefulWidget {
  const GuruDashboardScreen({super.key});

  @override
  State<GuruDashboardScreen> createState() => _GuruDashboardScreenState();
}

class _GuruDashboardScreenState extends State<GuruDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuruScope.of(context).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final guru = GuruScope.of(context);
    final user = session.user;
    final data = guru.dashboard;

    return AsyncStateView(
      state: guru.dashboardState,
      errorMessage: guru.dashboardError,
      emptyMessage: 'Belum ada data dashboard guru.',
      onRetry: guru.loadDashboard,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      child: data == null
          ? const SizedBox.shrink()
          : ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _Greeting(
                  name: user?.name ?? 'Guru',
                  roleLabel: user?.roleLabel ?? 'Guru',
                  initials: user?.initials ?? 'GR',
                  dateLabel: data.dateLabel,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.calendar_today_outlined,
                        iconColor: AppColors.accent,
                        iconBackground: AppColors.accentSoft,
                        label: 'Jadwal hari ini',
                        value: '${data.todaySessionCount}',
                        hint: 'Sesi mengajar',
                        onTap: () => session.setTab(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.meeting_room_outlined,
                        iconColor: AppColors.navy,
                        iconBackground: const Color(0xFFE8EEF7),
                        label: 'Kelas diampu',
                        value: '${data.classes.length}',
                        hint: data.classHint,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => GuruScope(
                                controller: guru,
                                child: const GuruClassesScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AttendanceSummaryCard(
                  slices: data.attendanceSummary,
                  hint: data.attendanceSummaryHint,
                  onTap: () => session.setTab(2),
                ),
                const SizedBox(height: 22),
                _SectionTitle(
                  title: 'Jadwal mengajar',
                  action: 'Lihat semua',
                  onAction: () => session.setTab(1),
                ),
                const SizedBox(height: 10),
                if (data.todaySchedule.isEmpty)
                  Text(
                    'Tidak ada jadwal hari ini.',
                    style: AppText.style(size: 13.5, color: AppColors.muted),
                  )
                else
                  for (final item in data.todaySchedule) ...[
                    ScheduleCard(
                      item: item,
                      onTap: () => showScheduleDetail(context, item),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 12),
                const _SectionTitle(title: 'Pengumuman sekolah'),
                const SizedBox(height: 10),
                if (data.announcements.isEmpty)
                  Text(
                    'Belum ada pengumuman.',
                    style: AppText.style(size: 13.5, color: AppColors.muted),
                  )
                else
                  for (final item in data.announcements) ...[
                    AnnouncementCard(item: item),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 12),
                const _SectionTitle(title: 'Menu utama'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ShortcutTile(
                        icon: Icons.calendar_month_outlined,
                        label: 'Jadwal',
                        onTap: () => session.setTab(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShortcutTile(
                        icon: Icons.groups_outlined,
                        label: 'Kelas',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => GuruScope(
                                controller: guru,
                                child: const GuruClassesScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShortcutTile(
                        icon: Icons.fact_check_outlined,
                        label: 'Absensi',
                        onTap: () => session.setTab(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShortcutTile(
                        icon: Icons.history_rounded,
                        label: 'Riwayat',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => GuruScope(
                                controller: guru,
                                child: const GuruAttendanceHistoryScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.name,
    required this.roleLabel,
    required this.initials,
    required this.dateLabel,
  });

  final String name;
  final String roleLabel;
  final String initials;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamu\'alaikum,',
                style: AppText.style(size: 13.5, color: AppColors.muted),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppText.style(
                  size: 22,
                  weight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                roleLabel,
                style: AppText.style(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.navyMid,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.today_outlined,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: AppText.style(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _Avatar(initials: initials),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFC5D8F0)),
      ),
      child: Text(
        initials,
        style: AppText.style(
          size: 16,
          weight: FontWeight.w800,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppText.style(
              size: 16,
              weight: FontWeight.w800,
              color: AppColors.navy,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: AppText.style(
                size: 13,
                weight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
      ],
    );
  }
}
