import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lms_app_bar.dart';

class GuruAttendanceHistoryScreen extends StatefulWidget {
  const GuruAttendanceHistoryScreen({super.key});

  @override
  State<GuruAttendanceHistoryScreen> createState() =>
      _GuruAttendanceHistoryScreenState();
}

class _GuruAttendanceHistoryScreenState
    extends State<GuruAttendanceHistoryScreen> {
  String _month = DummyData.monthFilters.first;

  @override
  Widget build(BuildContext context) {
    final rate = DummyData.classPresentPercent;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Riwayat Absensi', showBack: true),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
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
                  'Ringkasan kehadiran',
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${rate.toStringAsFixed(0)}%',
                  style: AppText.style(
                    size: 32,
                    weight: FontWeight.w800,
                    color: AppColors.accent,
                    height: 1.1,
                    letterSpacing: -0.8,
                  ),
                ),
                Text(
                  'Persentase hadir kelas V-A bulan ini',
                  style: AppText.style(size: 12.5, color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (final item in DummyData.attendance) ...[
                      if (item != DummyData.attendance.first)
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
            'Daftar riwayat',
            style: AppText.style(
              size: 16,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in DummyData.attendanceHistory) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dateLabel,
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.subject} · Kelas ${item.className}',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MiniStat(
                        label: 'H',
                        value: item.present,
                        color: AppColors.success,
                        background: AppColors.successSoft,
                      ),
                      const SizedBox(width: 6),
                      _MiniStat(
                        label: 'I',
                        value: item.permission,
                        color: AppColors.warningInk,
                        background: AppColors.warningSoft,
                      ),
                      const SizedBox(width: 6),
                      _MiniStat(
                        label: 'S',
                        value: item.sick,
                        color: AppColors.purple,
                        background: AppColors.purpleSoft,
                      ),
                      const SizedBox(width: 6),
                      _MiniStat(
                        label: 'A',
                        value: item.absent,
                        color: AppColors.danger,
                        background: AppColors.dangerSoft,
                      ),
                      const Spacer(),
                      Text(
                        '${item.presentRate.toStringAsFixed(0)}%',
                        style: AppText.style(
                          size: 14,
                          weight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final int value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppText.style(
              size: 13,
              weight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppText.style(
              size: 10,
              weight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
