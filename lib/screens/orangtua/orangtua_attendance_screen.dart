import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/attendance_status_chip.dart';

class OrangtuaAttendanceScreen extends StatefulWidget {
  const OrangtuaAttendanceScreen({super.key});

  @override
  State<OrangtuaAttendanceScreen> createState() =>
      _OrangtuaAttendanceScreenState();
}

class _OrangtuaAttendanceScreenState extends State<OrangtuaAttendanceScreen> {
  String _month = DummyData.monthFilters.first;

  @override
  Widget build(BuildContext context) {
    final percent = DummyData.childPresentPercent;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Kehadiran anak',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DummyData.childName,
          style: AppText.style(
            size: 13.5,
            weight: FontWeight.w600,
            color: AppColors.navyMid,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status kehadiran hari ini',
                style: AppText.style(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const AttendanceStatusChip(status: AttendanceStatus.hadir),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DummyData.demoDateLabel,
                      style: AppText.style(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistik kehadiran',
                style: AppText.style(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: AppText.style(
                  size: 32,
                  weight: FontWeight.w800,
                  color: AppColors.accent,
                  height: 1.1,
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                'Persentase kehadiran bulan ini',
                style: AppText.style(size: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final item in DummyData.childAttendanceMonth) ...[
                    if (item != DummyData.childAttendanceMonth.first)
                      const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: item.background,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${item.value}',
                              style: AppText.style(
                                size: 15,
                                weight: FontWeight.w800,
                                color: item.color,
                              ),
                            ),
                            Text(
                              item.label,
                              style: AppText.style(
                                size: 11,
                                weight: FontWeight.w600,
                                color: item.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter bulan',
                style: AppText.style(size: 11.5, color: AppColors.muted),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _month,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.navy,
                  ),
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                  items: [
                    for (final month in DummyData.monthFilters)
                      DropdownMenuItem(value: month, child: Text(month)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _month = value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Riwayat absensi',
          style: AppText.style(
            size: 16,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in DummyData.childAttendanceDays) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: item.status.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.status.icon,
                    color: item.status.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.dayLabel}, ${item.dateLabel}',
                        style: AppText.style(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.note,
                        style: AppText.style(
                          size: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                AttendanceStatusChip(status: item.status),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
