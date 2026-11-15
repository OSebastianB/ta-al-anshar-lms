import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/section_header.dart';

class OrangtuaProfileScreen extends StatelessWidget {
  const OrangtuaProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const ProfileHeader(
          name: DummyData.parentName,
          role: 'Orang Tua / Wali Murid',
          initials: DummyData.parentInitials,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi akun'),
        const SizedBox(height: 10),
        const ProfileInfoTile(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: DummyData.parentEmail,
        ),
        const SizedBox(height: 8),
        const ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: 'Nomor telepon',
          value: DummyData.parentPhone,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi anak'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC5D8F0)),
                ),
                child: Text(
                  DummyData.childInitials,
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DummyData.childName,
                      style: AppText.style(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DummyData.childClass} · NIS ${DummyData.childNis}',
                      style: AppText.style(size: 12.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Wali kelas: ${DummyData.guruName}',
                      style: AppText.style(size: 12.5, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
