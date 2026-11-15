import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
    required this.hint,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppText.style(
                    size: 24,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                    height: 1.1,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(
                    size: 11.5,
                    weight: FontWeight.w500,
                    color: AppColors.muted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fact_check_outlined,
                        size: 18,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ringkasan absensi',
                            style: AppText.style(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            'Kelas V-A · 32 siswa · 91% hadir',
                            style: AppText.style(
                              size: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (var i = 0; i < DummyData.attendance.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(child: _Slice(item: DummyData.attendance[i])),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Slice extends StatelessWidget {
  const _Slice({required this.item});

  final AttendanceSlice item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: item.background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Text(
            '${item.value}',
            style: AppText.style(
              size: 16,
              weight: FontWeight.w800,
              color: item.color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }
}
