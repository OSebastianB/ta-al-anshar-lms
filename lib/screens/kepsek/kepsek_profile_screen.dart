import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/section_header.dart';
import 'kepsek_announcements_screen.dart';
import 'kepsek_reports_screen.dart';

class KepsekProfileScreen extends StatelessWidget {
  const KepsekProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const ProfileHeader(
          name: DummyData.kepsekName,
          role: DummyData.kepsekRole,
          initials: DummyData.kepsekInitials,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi akun'),
        const SizedBox(height: 10),
        const ProfileInfoTile(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: DummyData.kepsekEmail,
        ),
        const SizedBox(height: 8),
        const ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: 'Nomor telepon',
          value: DummyData.kepsekPhone,
        ),
        const SizedBox(height: 8),
        const ProfileInfoTile(
          icon: Icons.apartment_outlined,
          label: 'Jabatan',
          value: 'Kepala Sekolah SD Islam Al-Anshar',
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Pengaturan akun'),
        const SizedBox(height: 10),
        ProfileActionTile(
          icon: Icons.bar_chart_rounded,
          label: 'Laporan akademik',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KepsekReportsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.campaign_outlined,
          label: 'Pengumuman sekolah',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const KepsekAnnouncementsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.lock_outline_rounded,
          label: 'Ubah password',
          onTap: () => _demo(context, 'Ubah password'),
        ),
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.notifications_outlined,
          label: 'Preferensi notifikasi',
          onTap: () => _demo(context, 'Preferensi notifikasi'),
        ),
        const SizedBox(height: 16),
        ProfileActionTile(
          icon: Icons.logout_rounded,
          label: 'Keluar',
          danger: true,
          onTap: session.logout,
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Mode demo · data tidak disimpan',
            style: AppText.style(size: 11.5, color: AppColors.muted),
          ),
        ),
      ],
    );
  }

  void _demo(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        content: Text(
          '$label hanya elemen visual pada mockup.',
          style: AppText.style(size: 13, color: Colors.white),
        ),
      ),
    );
  }
}
