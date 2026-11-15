import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
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
  late final List<SchoolAnnouncement> _items;

  @override
  void initState() {
    super.initState();
    _items = List<SchoolAnnouncement>.from(DummyData.schoolAnnouncements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: LmsAppBar(title: 'Pengumuman Sekolah', showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateCreate,
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Buat',
          style: AppText.style(
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
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
            'Simulasi membuat pengumuman tanpa penyimpanan permanen.',
            style: AppText.style(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          for (final item in _items) ...[
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
                                item.published ? 'Dipublikasikan' : 'Draft',
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
      ),
    );
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

  void _simulateCreate() {
    setState(() {
      _items.insert(
        0,
        SchoolAnnouncement(
          id: 'local-${_items.length + 1}',
          title: 'Pengumuman baru (simulasi)',
          body:
              'Draft pengumuman dari kepala sekolah. Tidak disimpan ke database.',
          dateLabel: '16 Nov 2026',
          author: DummyData.kepsekName,
          published: false,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        content: Text(
          'Draft pengumuman ditambahkan (simulasi).',
          style: AppText.style(size: 13, color: Colors.white),
        ),
      ),
    );
  }
}
