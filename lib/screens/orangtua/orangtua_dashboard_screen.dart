import 'package:material_ui/material_ui.dart';

import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/attendance_status_chip.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/schedule_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/summary_card.dart';
import '../common/notifications_screen.dart';

class OrangtuaDashboardScreen extends StatefulWidget {
  const OrangtuaDashboardScreen({super.key});

  @override
  State<OrangtuaDashboardScreen> createState() =>
      _OrangtuaDashboardScreenState();
}

class _OrangtuaDashboardScreenState extends State<OrangtuaDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parent = ParentScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) parent.bindParent(userId);
      parent.loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final parent = ParentScope.of(context);
    final user = session.user;
    final data = parent.dashboard;

    return AsyncStateView(
      state: parent.dashboardState,
      errorMessage: parent.dashboardError,
      emptyMessage:
          parent.dashboardError ??
          'Tidak ada anak yang terhubung dengan akun ini.',
      onRetry: parent.loadDashboard,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      child: data == null
          ? const SizedBox.shrink()
          : ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Text(
                  'Assalamu\'alaikum,',
                  style: AppText.style(size: 13.5, color: AppColors.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.name ?? 'Orang Tua',
                  style: AppText.style(
                    size: 22,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFC5D8F0)),
                        ),
                        child: Text(
                          data.child.initials,
                          style: AppText.style(
                            size: 14,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.child.name,
                              style: AppText.style(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${data.child.classLabel} · NIS ${data.child.nis}',
                              style: AppText.style(
                                size: 12.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kehadiran hari ini',
                              style: AppText.style(
                                size: 12,
                                weight: FontWeight.w600,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AttendanceStatusChip(status: data.todayStatus),
                            const SizedBox(height: 6),
                            Text(
                              data.dateLabel,
                              style: AppText.style(
                                size: 11.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.pie_chart_outline_rounded,
                        iconColor: AppColors.accent,
                        iconBackground: AppColors.accentSoft,
                        label: 'Bulanan',
                        value:
                            '${data.monthlyPresentPercent.toStringAsFixed(0)}%',
                        hint: 'Persentase hadir',
                        onTap: () => session.setTab(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Jadwal pelajaran hari ini',
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
                  for (final item in data.todaySchedule.take(3)) ...[
                    ScheduleCard(
                      item: item,
                      onTap: () => showScheduleDetail(context, item),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 12),
                const SectionHeader(title: 'Pengumuman sekolah'),
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
                SectionHeader(
                  title: 'Notifikasi terbaru',
                  action: 'Semua',
                  onAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (data.notices.isEmpty)
                  Text(
                    'Belum ada notifikasi.',
                    style: AppText.style(size: 13.5, color: AppColors.muted),
                  )
                else
                  for (final item in data.notices.take(2)) ...[
                    NotificationItem(item: item),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
    );
  }
}
