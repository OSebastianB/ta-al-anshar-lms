import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/student_list_item.dart';
import 'guru_attendance_history_screen.dart';

class GuruAttendanceScreen extends StatefulWidget {
  const GuruAttendanceScreen({super.key});

  @override
  State<GuruAttendanceScreen> createState() => _GuruAttendanceScreenState();
}

class _GuruAttendanceScreenState extends State<GuruAttendanceScreen> {
  String _className = DummyData.classOptions.first;
  String _subject = DummyData.subjectOptions.first;
  late Map<String, AttendanceStatus> _statuses;

  @override
  void initState() {
    super.initState();
    _statuses = {
      for (final student in DummyData.studentsVa) student.nis: student.status,
    };
  }

  Map<AttendanceStatus, int> get _summary {
    final counts = {
      for (final status in AttendanceStatus.values) status: 0,
    };
    for (final status in _statuses.values) {
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Absensi kelas',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DummyData.demoDateLabel,
          style: AppText.style(size: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _DropdownCard(
                label: 'Kelas',
                value: _className,
                options: DummyData.classOptions,
                onChanged: (value) => setState(() => _className = value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DropdownCard(
                label: 'Mata pelajaran',
                value: _subject,
                options: DummyData.subjectOptions,
                onChanged: (value) => setState(() => _subject = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ringkasan kehadiran',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const GuruAttendanceHistoryScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Riwayat',
                      style: AppText.style(
                        size: 12.5,
                        weight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final status in AttendanceStatus.values) ...[
                    if (status != AttendanceStatus.values.first)
                      const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: status.background,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${summary[status] ?? 0}',
                              style: AppText.style(
                                size: 16,
                                weight: FontWeight.w800,
                                color: status.color,
                              ),
                            ),
                            Text(
                              status.label,
                              style: AppText.style(
                                size: 11,
                                weight: FontWeight.w600,
                                color: status.color,
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
        const SizedBox(height: 16),
        Text(
          'Daftar siswa',
          style: AppText.style(
            size: 16,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        for (final student in DummyData.studentsVa) ...[
          StudentListItem(
            student: student,
            selectedStatus: _statuses[student.nis],
            onStatusChanged: (status) {
              setState(() => _statuses[student.nis] = status);
            },
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.navy,
                  content: Text(
                    'Absensi $_className · $_subject tersimpan (simulasi).',
                    style: AppText.style(size: 13, color: Colors.white),
                  ),
                ),
              );
            },
            child: Text(
              'Simpan absensi',
              style: AppText.style(
                size: 15,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            label,
            style: AppText.style(size: 11.5, color: AppColors.muted),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
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
                for (final option in options)
                  DropdownMenuItem(value: option, child: Text(option)),
              ],
              onChanged: (selected) {
                if (selected != null) onChanged(selected);
              },
            ),
          ),
        ],
      ),
    );
  }
}
