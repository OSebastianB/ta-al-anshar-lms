import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/attendance_status_chip.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/schedule_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/summary_card.dart';
import '../common/notifications_screen.dart';

class OrangtuaDashboardScreen extends StatelessWidget {
  const OrangtuaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final today = DummyData.childWeeklySchedule['senin'] ?? const <ScheduleItem>[];

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Assalamu\'alaikum,',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          DummyData.parentName,
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
                  DummyData.childInitials,
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
                      DummyData.childName,
                      style: AppText.style(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DummyData.childClass} · NIS ${DummyData.childNis}',
                      style: AppText.style(size: 12.5, color: AppColors.muted),
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
                    const AttendanceStatusChip(status: AttendanceStatus.hadir),
                    const SizedBox(height: 6),
                    Text(
                      DummyData.demoDateLabel,
                      style: AppText.style(size: 11.5, color: AppColors.muted),
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
                value: '${DummyData.childPresentPercent.toStringAsFixed(0)}%',
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
        for (final item in today.take(3)) ...[
          ScheduleCard(
            item: item,
            onTap: () => showScheduleDetail(context, item),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        const SectionHeader(title: 'Pengumuman sekolah'),
        const SizedBox(height: 10),
        for (final item in DummyData.parentAnnouncements) ...[
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
        for (final item in DummyData.parentNotices.take(2)) ...[
          NotificationItem(item: item),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
