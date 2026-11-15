import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.initials,
  });

  final String name;
  final String role;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC5D8F0), width: 2),
            ),
            child: Text(
              initials,
              style: AppText.style(
                size: 22,
                weight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppText.style(
              size: 18,
              weight: FontWeight.w800,
              color: AppColors.navy,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: AppText.style(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.navyMid,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.slateSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.navy),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppText.style(size: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.navy;
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: danger ? const Color(0xFFF3C1C1) : AppColors.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: danger ? AppColors.danger : AppColors.borderStrong,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
