import 'package:material_ui/material_ui.dart';

import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/day_selector.dart';
import '../../widgets/schedule_card.dart';
import '../../widgets/section_header.dart';

class OrangtuaScheduleScreen extends StatefulWidget {
  const OrangtuaScheduleScreen({super.key});

  @override
  State<OrangtuaScheduleScreen> createState() => _OrangtuaScheduleScreenState();
}

class _OrangtuaScheduleScreenState extends State<OrangtuaScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parent = ParentScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) parent.bindParent(userId);
      parent.loadSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parent = ParentScope.of(context);
    final data = parent.schedule;

    if (parent.scheduleState == LoadState.loading ||
        parent.scheduleState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat jadwal...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (parent.scheduleState == LoadState.empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            parent.scheduleError ??
                'Tidak ada anak yang terhubung dengan akun ini.',
            textAlign: TextAlign.center,
            style: AppText.style(size: 14, color: AppColors.muted),
          ),
        ),
      );
    }

    if (parent.scheduleState == LoadState.error || data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                parent.scheduleError ?? 'Gagal memuat jadwal.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => parent.loadSchedule(),
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

    final day = data.selectedDay;
    final childFirstName = data.child.name.split(' ').first;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Jadwal $childFirstName',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${data.child.classLabel} · mata pelajaran, guru, jam, dan ruangan.',
          style: AppText.style(size: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        if (data.weekDays.isNotEmpty)
          DaySelector(
            days: data.weekDays,
            selectedKey: data.selectedDayKey,
            onSelected: parent.selectScheduleDay,
          ),
        const SizedBox(height: 16),
        if (day != null) ...[
          SectionHeader(title: '${day.label}, ${day.dateLabel}'),
          const SizedBox(height: 10),
        ],
        if (data.items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Tidak ada jadwal pada hari ini.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final item in data.items) ...[
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
