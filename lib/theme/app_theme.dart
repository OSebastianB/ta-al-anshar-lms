import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

abstract final class AppText {
  static const family = 'PlusJakartaSans';

  static TextStyle style({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.text,
    double height = 1.35,
    double letterSpacing = -0.15,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppText.family,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: Colors.white,
        secondary: AppColors.navy,
        onSecondary: Colors.white,
        surface: AppColors.card,
        onSurface: AppColors.text,
        error: AppColors.danger,
        outline: AppColors.border,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: AppText.family,
        bodyColor: AppColors.text,
        displayColor: AppColors.navy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.card,
        centerTitle: false,
      ),
      splashColor: AppColors.accentSoft,
      highlightColor: const Color(0x143978C6),
      dividerColor: AppColors.border,
    );
  }
}
