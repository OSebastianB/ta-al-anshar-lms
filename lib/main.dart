import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.card,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const LmsApp());
}
