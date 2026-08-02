import 'package:flutter/material.dart';

import '../ui/app_colors.dart';
import '../ui/app_spacing.dart';
import '../ui/app_typography.dart';
import 'app_primary_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.retryLabel = 'Reintentar',
    this.onRetry,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final resolvedAction = onRetry ?? onAction;
    final resolvedLabel = onRetry != null ? retryLabel : actionLabel;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppSpacing.xxl * 2,
              color: AppColors.danger,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (resolvedLabel != null && resolvedAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: resolvedLabel,
                onPressed: resolvedAction,
                icon: Icons.refresh,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
