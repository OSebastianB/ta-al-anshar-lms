import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lms_app_bar.dart';
import '../../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NoticeKind? _filter;

  @override
  Widget build(BuildContext context) {
    final role = SessionScope.of(context).role;
    final source = switch (role) {
      AppRole.orangTua => DummyData.parentNotices,
      AppRole.kepalaSekolah => DummyData.kepsekNotices,
      _ => DummyData.notices,
    };
    final unread = switch (role) {
      AppRole.orangTua => DummyData.parentUnreadCount,
      AppRole.kepalaSekolah => DummyData.kepsekUnreadCount,
      _ => DummyData.unreadCount,
    };
    final items = _filter == null
        ? source
        : source.where((item) => item.kind == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(
        title: 'Notifikasi',
        showBack: true,
        unreadOverride: unread,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            'Filter kategori',
            style: AppText.style(
              size: 13,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'Semua',
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              for (final kind in NoticeKind.values)
                _FilterChip(
                  label: kind.label,
                  selected: _filter == kind,
                  color: kind.color,
                  onTap: () => setState(() => _filter = kind),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Tidak ada notifikasi pada kategori ini.',
                style: AppText.style(size: 13.5, color: AppColors.muted),
              ),
            )
          else
            for (final item in items) ...[
              NotificationItem(
                item: item,
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
                            size: 17,
                            weight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        content: Text(
                          item.body,
                          style: AppText.style(
                            size: 14,
                            color: AppColors.text,
                            height: 1.45,
                          ),
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
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final active = color ?? AppColors.accent;
    return Material(
      color: selected ? active : AppColors.card,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? active : AppColors.border),
          ),
          child: Text(
            label,
            style: AppText.style(
              size: 12,
              weight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
