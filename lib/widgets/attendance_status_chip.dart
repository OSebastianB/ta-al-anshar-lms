import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';

class AttendanceStatusChip extends StatelessWidget {
  const AttendanceStatusChip({super.key, required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: AppText.style(
          size: 11.5,
          weight: FontWeight.w700,
          color: status.color,
        ),
      ),
    );
  }
}

class AttendanceStatusButton extends StatelessWidget {
  const AttendanceStatusButton({
    super.key,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final AttendanceStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? status.color : status.background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 34,
          alignment: Alignment.center,
          child: Text(
            status.label,
            style: AppText.style(
              size: 11,
              weight: FontWeight.w700,
              color: selected ? Colors.white : status.color,
            ),
          ),
        ),
      ),
    );
  }
}
