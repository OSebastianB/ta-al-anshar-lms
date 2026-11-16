import 'package:material_ui/material_ui.dart';

import '../../state/guru_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/day_selector.dart';
import '../../widgets/schedule_card.dart';
import '../../widgets/section_header.dart';

class GuruScheduleScreen extends StatefulWidget {
  const GuruScheduleScreen({super.key});

  @override
  State<GuruScheduleScreen> createState() => _GuruScheduleScreenState();
}

class _GuruScheduleScreenState extends State<GuruScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuruScope.of(context).loadSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guru = GuruScope.of(context);
    final day = guru.selectedDay;

    if (guru.scheduleState == LoadState.loading ||
        guru.scheduleState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat jadwal...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (guru.scheduleState == LoadState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                guru.scheduleError ?? 'Gagal memuat jadwal.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => guru.loadSchedule(),
                child: Text(
                  'Coba lagi',
                  style: AppText.style(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Jadwal mengajar minggu ini',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih hari untuk melihat sesi mengajar.',
          style: AppText.style(size: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        if (guru.weekDays.isNotEmpty)
          DaySelector(
            days: guru.weekDays,
            selectedKey: guru.selectedDayKey,
            onSelected: guru.selectScheduleDay,
          ),
        const SizedBox(height: 16),
        if (day != null) ...[
          SectionHeader(title: '${day.label}, ${day.dateLabel}'),
          const SizedBox(height: 10),
        ],
        if (guru.scheduleItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Tidak ada jadwal mengajar pada hari ini.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final item in guru.scheduleItems) ...[
            ScheduleCard(
              item: item,
              onTap: () => showScheduleDetail(context, item),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}
