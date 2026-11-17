import 'package:material_ui/material_ui.dart';

import '../../state/parent_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/section_header.dart';

class OrangtuaProfileScreen extends StatefulWidget {
  const OrangtuaProfileScreen({super.key});

  @override
  State<OrangtuaProfileScreen> createState() => _OrangtuaProfileScreenState();
}

class _OrangtuaProfileScreenState extends State<OrangtuaProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parent = ParentScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) parent.bindParent(userId);
      if (parent.linkedChildren.isEmpty) {
        parent.loadLinkedChildren();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final parent = ParentScope.of(context);
    final user = session.user;
    final child = parent.activeChild ?? parent.dashboard?.child;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        ProfileHeader(
          name: user?.name ?? 'Orang Tua',
          role: user?.roleLabel ?? 'Orang Tua / Wali Murid',
          initials: user?.initials ?? 'OT',
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi akun'),
        const SizedBox(height: 10),
        ProfileInfoTile(
          icon: Icons.mail_outline_rounded,
          label: 'Email',
          value: user?.email ?? '—',
        ),
        const SizedBox(height: 8),
        ProfileInfoTile(
          icon: Icons.phone_outlined,
          label: 'Nomor telepon',
          value: user?.phone ?? '—',
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Informasi anak'),
        const SizedBox(height: 10),
        if (child == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              parent.childrenError ??
                  'Tidak ada anak yang terhubung dengan akun ini.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final linked in parent.linkedChildren.isEmpty
              ? [child]
              : parent.linkedChildren) ...[
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
                      linked.initials,
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
                          linked.name,
                          style: AppText.style(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${linked.classLabel} · NIS ${linked.nis}',
                          style: AppText.style(
                            size: 12.5,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Wali kelas: ${linked.homeroomTeacher}',
                          style: AppText.style(
                            size: 12.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 6),
        const SectionHeader(title: 'Pengaturan akun'),
        const SizedBox(height: 10),
        ProfileActionTile(
          icon: Icons.lock_outline_rounded,
          label: 'Ubah password',
          onTap: () => showPendingFeature(context, 'Ubah password'),
        ),
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.notifications_outlined,
          label: 'Preferensi notifikasi',
          onTap: () => showPendingFeature(context, 'Preferensi notifikasi'),
        ),
        const SizedBox(height: 8),
        ProfileActionTile(
          icon: Icons.info_outline_rounded,
          label: 'Tentang aplikasi',
          onTap: () => showPendingFeature(context, 'Tentang aplikasi'),
        ),
        const SizedBox(height: 16),
        const ProfileLogoutTile(),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Data anak dibatasi sesuai akun yang login',
            style: AppText.style(size: 11.5, color: AppColors.muted),
          ),
        ),
      ],
    );
  }
}
