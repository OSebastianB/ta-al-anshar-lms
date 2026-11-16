import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/section_header.dart';

class GuruProfileScreen extends StatelessWidget {
  const GuruProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        ProfileHeader(
          name: user?.name ?? DummyData.guruName,
          role: user?.roleLabel ??
              '${DummyData.guruRole} · ${DummyData.guruHomeroom}',
          initials: user?.initials ?? DummyData.guruInitials,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi akun'),
        const SizedBox(height: 10),
        ProfileInfoTile(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: user?.email ?? DummyData.guruEmail,
        ),
        const SizedBox(height: 8),
        ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: 'Nomor telepon',
          value: user?.phone ?? DummyData.guruPhone,
        ),
        const SizedBox(height: 8),
        const ProfileInfoTile(
          icon: Icons.school_outlined,
          label: 'Peran',
          value: 'Guru / Wali Kelas',
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Pengaturan akun'),
        const SizedBox(height: 10),
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
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.info_outline_rounded,
          label: 'Tentang aplikasi',
          onTap: () => _demo(context, 'Tentang aplikasi'),
        ),
        const SizedBox(height: 16),
        ProfileActionTile(
          icon: Icons.logout_rounded,
          label: 'Keluar',
          danger: true,
          onTap: session.isAuthenticating ? null : () => session.logout(),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Sesi aktif · logout membersihkan token lokal',
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
