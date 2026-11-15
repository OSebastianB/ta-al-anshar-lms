import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.item, this.onTap});

  final ScheduleItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = item.teacher == null
        ? 'Kelas ${item.className}  ·  ${item.room}'
        : '${item.teacher}  ·  ${item.room}';

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
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 68,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.start,
                        style: AppText.style(
                          size: 13,
                          weight: FontWeight.w800,
                          color: AppColors.navy,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.end,
                        style: AppText.style(
                          size: 11,
                          weight: FontWeight.w500,
                          color: AppColors.navyMid,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.style(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.style(
                          size: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.borderStrong,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showScheduleDetail(BuildContext context, ScheduleItem item) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.card,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.subject,
              style: AppText.style(
                size: 20,
                weight: FontWeight.w800,
                color: AppColors.navy,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Detail jadwal',
              style: AppText.style(size: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Kelas', value: item.className),
            _DetailRow(
              label: 'Jam pelajaran',
              value: '${item.start} – ${item.end}',
            ),
            _DetailRow(label: 'Ruangan', value: item.room),
            _DetailRow(
              label: 'Guru',
              value: item.teacher ?? DummyData.guruName,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppText.style(size: 13, color: AppColors.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.style(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
