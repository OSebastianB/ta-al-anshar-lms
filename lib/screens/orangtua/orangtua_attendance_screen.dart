import 'package:material_ui/material_ui.dart';

import '../../models/models.dart';
import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parent = ParentScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) parent.bindParent(userId);
      parent.loadAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final parent = ParentScope.of(context);
    final data = parent.attendance;

    if (parent.attendanceState == LoadState.loading ||
        parent.attendanceState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat kehadiran...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (parent.attendanceState == LoadState.empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            parent.attendanceError ??
                'Tidak ada anak yang terhubung dengan akun ini.',
            textAlign: TextAlign.center,
            style: AppText.style(size: 14, color: AppColors.muted),
          ),
        ),
      );
    }

    if (parent.attendanceState == LoadState.error || data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                parent.attendanceError ?? 'Gagal memuat kehadiran.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => parent.loadAttendance(),
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
          'Kehadiran anak',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data.child.name,
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
                  AttendanceStatusChip(status: data.todayStatus),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.dateLabel,
                          style: AppText.style(
                            size: 13,
                            weight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          data.todayNote,
                          style: AppText.style(
                            size: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
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
                '${data.monthlyPresentPercent.toStringAsFixed(0)}%',
                style: AppText.style(
                  size: 32,
                  weight: FontWeight.w800,
                  color: AppColors.accent,
                  height: 1.1,
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                'Persentase kehadiran ${data.selectedMonth}',
                style: AppText.style(size: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < data.monthSummary.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: data.monthSummary[i].background,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${data.monthSummary[i].value}',
                              style: AppText.style(
                                size: 15,
                                weight: FontWeight.w800,
                                color: data.monthSummary[i].color,
                              ),
                            ),
                            Text(
                              data.monthSummary[i].label,
                              style: AppText.style(
                                size: 11,
                                weight: FontWeight.w600,
                                color: data.monthSummary[i].color,
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
                  value: data.selectedMonth,
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
                    for (final month in data.monthOptions)
                      DropdownMenuItem(value: month, child: Text(month)),
                  ],
                  onChanged: (value) {
                    if (value != null) parent.loadAttendance(month: value);
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
        if (data.history.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Belum ada riwayat kehadiran untuk ${data.selectedMonth}.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final item in data.history) ...[
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
