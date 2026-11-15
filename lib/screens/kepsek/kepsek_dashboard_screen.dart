import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shortcut_tile.dart';
import '../../widgets/summary_card.dart';
import '../common/notifications_screen.dart';
import 'kepsek_announcements_screen.dart';
import 'kepsek_reports_screen.dart';

class KepsekDashboardScreen extends StatelessWidget {
  const KepsekDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final pending = DummyData.createScheduleApprovals()
        .where((item) => item.status == ScheduleApprovalStatus.menunggu)
        .length;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
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
                    DummyData.kepsekName,
                    style: AppText.style(
                      size: 22,
                      weight: FontWeight.w800,
                      color: AppColors.navy,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DummyData.kepsekRole,
                    style: AppText.style(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.navyMid,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                          DummyData.demoDateLabel,
                          style: AppText.style(
                            size: 12,
                            weight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC5D8F0)),
              ),
              child: Text(
                DummyData.kepsekInitials,
                style: AppText.style(
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.groups_outlined,
                iconColor: AppColors.accent,
                iconBackground: AppColors.accentSoft,
                label: 'Total siswa',
                value: '${DummyData.totalStudents}',
                hint: 'Seluruh tingkat',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.badge_outlined,
                iconColor: AppColors.navy,
                iconBackground: const Color(0xFFE8EEF7),
                label: 'Total guru',
                value: '${DummyData.totalTeachers}',
                hint: 'Aktif mengajar',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.meeting_room_outlined,
                iconColor: AppColors.purple,
                iconBackground: AppColors.purpleSoft,
                label: 'Total kelas',
                value: '${DummyData.totalClasses}',
                hint: 'I–VI',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.pie_chart_outline_rounded,
                iconColor: AppColors.success,
                iconBackground: AppColors.successSoft,
                label: 'Hadir siswa',
                value: '${DummyData.studentPresencePercent.toStringAsFixed(0)}%',
                hint:
                    'Guru ${DummyData.teacherPresencePercent.toStringAsFixed(0)}%',
                onTap: () => session.setTab(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: AppColors.warningSoft,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: () => session.setTab(2),
            borderRadius: BorderRadius.circular(13),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFF3DFB8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.pending_actions_outlined,
                        color: AppColors.warningInk,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal menunggu persetujuan',
                            style: AppText.style(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            '$pending hasil generate CSP siap ditinjau',
                            style: AppText.style(
                              size: 12.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.warningInk,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const SectionHeader(title: 'Ringkasan aktivitas sekolah'),
        const SizedBox(height: 10),
        for (final item in DummyData.schoolActivities) ...[
          AnnouncementCard(item: item),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        SectionHeader(
          title: 'Jadwal pelajaran hari ini',
          action: 'Monitoring',
          onAction: () => session.setTab(1),
        ),
        const SizedBox(height: 10),
        for (final item in DummyData.todaySchoolSchedule.take(3)) ...[
          _SchoolScheduleTile(item: item),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        SectionHeader(
          title: 'Notifikasi penting',
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
        for (final item in DummyData.kepsekNotices.take(2)) ...[
          NotificationItem(item: item),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        const SectionHeader(title: 'Menu cepat'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ShortcutTile(
                icon: Icons.monitor_heart_outlined,
                label: 'Monitoring',
                onTap: () => session.setTab(1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ShortcutTile(
                icon: Icons.fact_check_outlined,
                label: 'Persetujuan',
                onTap: () => session.setTab(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ShortcutTile(
                icon: Icons.bar_chart_rounded,
                label: 'Laporan',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const KepsekReportsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ShortcutTile(
                icon: Icons.campaign_outlined,
                label: 'Pengumuman',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const KepsekAnnouncementsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SchoolScheduleTile extends StatelessWidget {
  const _SchoolScheduleTile({required this.item});

  final SchoolScheduleItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  item.start,
                  style: AppText.style(
                    size: 12,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  item.end,
                  style: AppText.style(
                    size: 11,
                    color: AppColors.navyMid,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelas ${item.className} · ${item.teacher}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(size: 12.5, color: AppColors.muted),
                ),
                Text(
                  item.room,
                  style: AppText.style(size: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
