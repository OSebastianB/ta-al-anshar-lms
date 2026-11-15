import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'attendance_status_chip.dart';

class StudentListItem extends StatelessWidget {
  const StudentListItem({
    super.key,
    required this.student,
    this.selectedStatus,
    this.onStatusChanged,
    this.showStatusOnly = false,
  });

  final StudentItem student;
  final AttendanceStatus? selectedStatus;
  final ValueChanged<AttendanceStatus>? onStatusChanged;
  final bool showStatusOnly;

  @override
  Widget build(BuildContext context) {
    final status = selectedStatus ?? student.status;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC5D8F0)),
                ),
                child: Text(
                  student.initials,
                  style: AppText.style(
                    size: 12,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIS ${student.nis}',
                      style: AppText.style(size: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (showStatusOnly || onStatusChanged == null)
                AttendanceStatusChip(status: status),
            ],
          ),
          if (onStatusChanged != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                for (final value in AttendanceStatus.values) ...[
                  if (value != AttendanceStatus.values.first)
                    const SizedBox(width: 6),
                  Expanded(
                    child: AttendanceStatusButton(
                      status: value,
                      selected: status == value,
                      onTap: () => onStatusChanged!(value),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
