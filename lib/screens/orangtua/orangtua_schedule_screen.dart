import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
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
  String _dayKey = DummyData.weekDays.first.key;

  @override
  Widget build(BuildContext context) {
    final day = DummyData.weekDays.firstWhere((item) => item.key == _dayKey);
    final items =
        DummyData.childWeeklySchedule[_dayKey] ?? const <ScheduleItem>[];

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Jadwal ${DummyData.childName.split(' ').first}',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${DummyData.childClass} · mata pelajaran, guru, jam, dan ruangan.',
          style: AppText.style(size: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        DaySelector(
          selectedKey: _dayKey,
          onSelected: (value) => setState(() => _dayKey = value),
        ),
        const SizedBox(height: 16),
        SectionHeader(title: '${day.label}, ${day.dateLabel}'),
        const SizedBox(height: 10),
        if (items.isEmpty)
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
          for (final item in items) ...[
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
