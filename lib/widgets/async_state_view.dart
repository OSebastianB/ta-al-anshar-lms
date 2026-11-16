import 'package:material_ui/material_ui.dart';

import '../state/load_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AsyncStateView extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.state,
    required this.child,
    this.errorMessage,
    this.emptyMessage = 'Data belum tersedia.',
    this.onRetry,
    this.padding = const EdgeInsets.all(24),
  });

  final LoadState state;
  final Widget child;
  final String? errorMessage;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (state == LoadState.loading || state == LoadState.idle) {
      return Padding(
        padding: padding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hourglass_top_rounded, color: AppColors.accent),
              const SizedBox(height: 10),
              Text(
                'Memuat data...',
                style: AppText.style(size: 13.5, color: AppColors.muted),
              ),
            ],
          ),
        ),
      );
    }

    if (state == LoadState.error) {
      return Padding(
        padding: padding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage ?? 'Terjadi kesalahan.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRetry,
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
            ],
          ),
        ),
      );
    }

    if (state == LoadState.empty) {
      return Padding(
        padding: padding,
        child: Center(
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: AppText.style(size: 14, color: AppColors.muted),
          ),
        ),
      );
    }

    return child;
  }
}
