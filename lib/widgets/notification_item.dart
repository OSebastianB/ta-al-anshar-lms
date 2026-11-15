import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.item, this.onTap});

  final AppNotice item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.unread ? AppColors.bg : AppColors.card,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.kind.label,
                              style: AppText.style(
                                size: 11,
                                weight: FontWeight.w700,
                                color: item.kind.color,
                              ),
                            ),
                          ),
                          Text(
                            item.timeLabel,
                            style: AppText.style(
                              size: 11,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.title,
                        style: AppText.style(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.body,
                        style: AppText.style(
                          size: 12.5,
                          color: AppColors.muted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.unread) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
