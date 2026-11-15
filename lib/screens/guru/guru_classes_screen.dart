import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/student_list_item.dart';

class GuruClassesScreen extends StatelessWidget {
  const GuruClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Kelas', showBack: true),
      body: ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: DummyData.classes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = DummyData.classes[index];
          return Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ClassDetailScreen(item: item),
                  ),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.accentSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.groups_outlined,
                              color: AppColors.accent,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kelas ${item.name}',
                                  style: AppText.style(
                                    size: 16,
                                    weight: FontWeight.w800,
                                    color: AppColors.navy,
                                  ),
                                ),
                                Text(
                                  item.level,
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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.person_outline,
                            label: '${item.studentCount} siswa',
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetaChip(
                              icon: Icons.badge_outlined,
                              label: 'Wali: ${item.homeroom}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Preview siswa',
                        style: AppText.style(
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final student in item.preview.take(4))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                student.name.split(' ').first,
                                style: AppText.style(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          if (item.preview.length > 4)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentSoft,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '+${item.studentCount - 4}',
                                style: AppText.style(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({super.key, required this.item});

  final ClassItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Kelas ${item.name}', showBack: true),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.level,
                  style: AppText.style(
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColors.navyMid,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.studentCount} siswa · Wali kelas ${item.homeroom}',
                  style: AppText.style(size: 13.5, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Daftar siswa',
            style: AppText.style(
              size: 16,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          for (final student in item.preview) ...[
            StudentListItem(student: student, showStatusOnly: true),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.style(
                size: 12,
                weight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
