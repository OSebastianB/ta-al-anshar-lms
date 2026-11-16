import 'package:material_ui/material_ui.dart';

import '../../core/errors/data_exception.dart';
import '../../models/models.dart';
import '../../state/guru_controller.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuruScope.of(context).loadAttendanceDraft();
    });
  }

  Map<AttendanceStatus, int> _summary(Map<String, AttendanceStatus> statuses) {
    final counts = {
      for (final status in AttendanceStatus.values) status: 0,
    };
    for (final status in statuses.values) {
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  Future<void> _save(GuruController guru) async {
    try {
      final saved = await guru.saveAttendance();
      if (!mounted || saved == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          content: Text(
            'Absensi ${saved.className} · ${saved.subject} berhasil disimpan.',
            style: AppText.style(size: 13, color: Colors.white),
          ),
        ),
      );
    } on DataException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text(
            error.message,
            style: AppText.style(size: 13, color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final guru = GuruScope.of(context);
    final draft = guru.attendanceDraft;

    if (guru.attendanceState == LoadState.loading ||
        guru.attendanceState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat absensi...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (guru.attendanceState == LoadState.error && draft == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                guru.attendanceError ?? 'Gagal memuat absensi.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => guru.loadAttendanceDraft(),
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

    if (draft == null) {
      return Center(
        child: Text(
          'Form absensi belum tersedia.',
          style: AppText.style(size: 14, color: AppColors.muted),
        ),
      );
    }

    final summary = _summary(draft.statuses);
    final saving = guru.isSavingAttendance;

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
          draft.dateLabel,
          style: AppText.style(size: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _DropdownCard(
                label: 'Kelas',
                value: draft.className,
                options: draft.classOptions,
                enabled: !saving,
                onChanged: guru.changeAttendanceClass,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DropdownCard(
                label: 'Mata pelajaran',
                value: draft.subject,
                options: draft.subjectOptions,
                enabled: !saving,
                onChanged: guru.changeAttendanceSubject,
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
                    onPressed: saving
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => GuruScope(
                                  controller: guru,
                                  child: const GuruAttendanceHistoryScreen(),
                                ),
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
        if (guru.attendanceError != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3C1C1)),
            ),
            child: Text(
              guru.attendanceError!,
              style: AppText.style(
                size: 12.5,
                color: const Color(0xFF9B2C2C),
              ),
            ),
          ),
        ],
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
        if (draft.students.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Tidak ada siswa pada kelas ini.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final student in draft.students) ...[
            StudentListItem(
              student: student,
              selectedStatus: draft.statuses[student.nis],
              onStatusChanged: saving
                  ? null
                  : (status) => guru.setAttendanceStatus(student.nis, status),
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
              disabledBackgroundColor:
                  AppColors.accent.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: saving || draft.students.isEmpty
                ? null
                : () => _save(guru),
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(
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
    this.enabled = true,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool enabled;

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
              onChanged: enabled
                  ? (selected) {
                      if (selected != null) onChanged(selected);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
