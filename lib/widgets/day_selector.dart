import 'package:material_ui/material_ui.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.days,
    required this.selectedKey,
    required this.onSelected,
  });

  final List<WeekDay> days;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final selected = day.key == selectedKey;
          return Material(
            color: selected ? AppColors.accent : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => onSelected(day.key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.accent : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.short,
                      style: AppText.style(
                        size: 12,
                        weight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.dateLabel.split(' ').first,
                      style: AppText.style(
                        size: 15,
                        weight: FontWeight.w800,
                        color: selected ? Colors.white : AppColors.navy,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
