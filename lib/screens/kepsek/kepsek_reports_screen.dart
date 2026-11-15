import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/section_header.dart';
import '../../widgets/simple_bar_chart.dart';

class KepsekReportsScreen extends StatelessWidget {
  const KepsekReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Laporan Akademik', showBack: true),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'Ringkasan aktivitas akademik',
            style: AppText.style(
              size: 16,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Data dummy untuk presentasi monitoring kepala sekolah.',
            style: AppText.style(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReportStat(
                  label: 'Hadir siswa',
                  value:
                      '${DummyData.studentPresencePercent.toStringAsFixed(0)}%',
                  color: AppColors.success,
                  background: AppColors.successSoft,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ReportStat(
                  label: 'Hadir guru',
                  value:
                      '${DummyData.teacherPresencePercent.toStringAsFixed(0)}%',
                  color: AppColors.accent,
                  background: AppColors.accentSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Grafik kehadiran bulanan'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: const SimpleBarChart(points: DummyData.monthlyPresenceChart),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Rekap kehadiran siswa per kelas'),
          const SizedBox(height: 10),
          for (final item in DummyData.classAttendanceStats) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Kelas ${item.className}',
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Text(
                    '${item.presentPercent.toStringAsFixed(0)}% · ${item.studentCount} siswa',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          const SectionHeader(title: 'Rekap kehadiran guru'),
          const SizedBox(height: 10),
          for (final item in DummyData.teacherAttendanceStats) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Text(
                    '${item.presentPercent.toStringAsFixed(0)}%',
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  const _ReportStat({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: AppText.style(
                size: 11,
                weight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppText.style(
              size: 26,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
