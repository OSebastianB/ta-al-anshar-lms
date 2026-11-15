import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.points,
    this.height = 140,
    this.barColor = AppColors.accent,
  });

  final List<ChartPoint> points;
  final double height;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.fold<double>(
      1,
      (max, point) => point.value > max ? point.value : max,
    );

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points) ...[
            if (point != points.first) const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    point.value.toStringAsFixed(0),
                    style: AppText.style(
                      size: 10,
                      weight: FontWeight.w700,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: (point.value / maxValue).clamp(0.08, 1),
                        widthFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    point.label,
                    style: AppText.style(
                      size: 11,
                      weight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
