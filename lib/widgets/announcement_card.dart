import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.item});

  final AnnouncementItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  item.title,
                  style: AppText.style(
                    size: 18,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                content: Text(
                  item.body,
                  style: AppText.style(size: 14, color: AppColors.text, height: 1.45),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: AppText.style(
                        weight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.kind.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.kind.icon, size: 18, color: item.kind.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
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
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.style(
                          size: 12.5,
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.timeLabel,
                        style: AppText.style(
                          size: 11,
                          weight: FontWeight.w600,
                          color: AppColors.navyMid,
                        ),
                      ),
                    ],
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
