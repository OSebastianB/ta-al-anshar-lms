import 'package:material_ui/material_ui.dart';

import '../../core/errors/data_exception.dart';
import '../../data/dummy_data.dart';
import '../../state/kepsek_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lms_app_bar.dart';

class KepsekAnnouncementsScreen extends StatefulWidget {
  const KepsekAnnouncementsScreen({super.key});

  @override
  State<KepsekAnnouncementsScreen> createState() =>
      _KepsekAnnouncementsScreenState();
}

class _KepsekAnnouncementsScreenState extends State<KepsekAnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kepsek = KepsekScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) kepsek.bindKepsek(userId);
      kepsek.loadAnnouncements();
    });
  }

  Future<void> _createDraft() async {
    final kepsek = KepsekScope.of(context);
    try {
      await kepsek.createAnnouncement(
        title: 'Pengumuman baru',
        body:
            'Draft pengumuman dari Kepala Sekolah. Tidak tersimpan ke database produksi.',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          content: Text(
            'Draft pengumuman ditambahkan.',
            style: AppText.style(size: 13, color: Colors.white),
          ),
        ),
      );
    } on DataException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text(
            error.message,
            style: AppText.style(size: 13, color: Colors.white),
          ),
        ),
      );
    }
  }

  void _showDetail(SchoolAnnouncement item) {
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
            '${item.body}\n\n${item.dateLabel}\n${item.author}',
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
  }

  @override
  Widget build(BuildContext context) {
    final kepsek = KepsekScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Pengumuman Sekolah', showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: kepsek.isSavingAnnouncement ? null : _createDraft,
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Buat',
          style: AppText.style(weight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (kepsek.announcementState == LoadState.loading ||
              kepsek.announcementState == LoadState.idle) {
            return Center(
              child: Text(
                'Memuat pengumuman...',
                style: AppText.style(size: 13.5, color: AppColors.muted),
              ),
            );
          }

          if (kepsek.announcementState == LoadState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kepsek.announcementError ?? 'Gagal memuat pengumuman.',
                      textAlign: TextAlign.center,
                      style: AppText.style(size: 14, color: AppColors.muted),
                    ),
                    TextButton(
                      onPressed: kepsek.loadAnnouncements,
                      child: Text(
                        'Coba lagi',
                        style: AppText.style(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = kepsek.announcements;
          return ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            children: [
              Text(
                'Daftar dan riwayat pengumuman',
                style: AppText.style(
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pengumuman sekolah untuk komunikasi internal. Bukan pengelolaan database.',
                style: AppText.style(size: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 14),
              if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Belum ada pengumuman.',
                    style: AppText.style(size: 13.5, color: AppColors.muted),
                  ),
                )
              else
                for (final item in items) ...[
                  Material(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(13),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => _showDetail(item),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: AppText.style(
                                        size: 15,
                                        weight: FontWeight.w700,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.published
                                          ? AppColors.successSoft
                                          : AppColors.warningSoft,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      item.published
                                          ? 'Dipublikasikan'
                                          : 'Draft',
                                      style: AppText.style(
                                        size: 11,
                                        weight: FontWeight.w700,
                                        color: item.published
                                            ? AppColors.success
                                            : AppColors.warningInk,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.style(
                                  size: 12.5,
                                  color: AppColors.muted,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item.dateLabel} · ${item.author}',
                                style: AppText.style(
                                  size: 11.5,
                                  weight: FontWeight.w600,
                                  color: AppColors.navyMid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }
}
