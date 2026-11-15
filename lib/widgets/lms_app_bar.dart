import 'package:material_ui/material_ui.dart';

import '../data/dummy_data.dart';
import '../screens/common/notifications_screen.dart';
import '../state/session_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class LmsAppBar extends AppBar {
  LmsAppBar({
    super.key,
    required String title,
    bool showBack = false,
    int? unreadOverride,
  }) : super(
         toolbarHeight: 63,
         automaticallyImplyLeading: false,
         backgroundColor: AppColors.card,
         surfaceTintColor: AppColors.card,
         elevation: 0,
         scrolledUnderElevation: 0,
         titleSpacing: showBack ? 0 : 16,
         leading: showBack
             ? Builder(
                 builder: (context) {
                   return IconButton(
                     tooltip: 'Kembali',
                     onPressed: () => Navigator.of(context).maybePop(),
                     icon: const Icon(
                       Icons.arrow_back_rounded,
                       color: AppColors.navy,
                     ),
                   );
                 },
               )
             : null,
         title: Row(
           children: [
             if (!showBack) ...[
               ClipOval(
                 child: Image.asset(
                   'assets/images/logo-al-anshar.jpg',
                   width: 32,
                   height: 32,
                   fit: BoxFit.cover,
                 ),
               ),
               const SizedBox(width: 10),
             ],
             Expanded(
               child: Text(
                 title,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: AppText.style(
                   size: 16,
                   weight: FontWeight.w700,
                   color: AppColors.navy,
                   letterSpacing: -0.3,
                 ),
               ),
             ),
           ],
         ),
         actions: [
           Builder(
             builder: (context) {
               final role = SessionScope.of(context).role;
               final unread = unreadOverride ??
                   switch (role) {
                     AppRole.orangTua => DummyData.parentUnreadCount,
                     AppRole.kepalaSekolah => DummyData.kepsekUnreadCount,
                     _ => DummyData.unreadCount,
                   };
               return IconButton(
                 tooltip: 'Notifikasi',
                 onPressed: () {
                   Navigator.of(context).push(
                     MaterialPageRoute<void>(
                       builder: (_) => const NotificationsScreen(),
                     ),
                   );
                 },
                 icon: Badge(
                   isLabelVisible: unread > 0,
                   label: Text('$unread'),
                   backgroundColor: AppColors.danger,
                   textColor: Colors.white,
                   child: const Icon(
                     Icons.notifications_none_rounded,
                     color: AppColors.navy,
                   ),
                 ),
               );
             },
           ),
           const SizedBox(width: 4),
         ],
         bottom: const PreferredSize(
           preferredSize: Size.fromHeight(1),
           child: Divider(height: 1, thickness: 1, color: AppColors.border),
         ),
       );
}
