import 'package:flutter/material.dart';

import '../ui/app_colors.dart';
import '../ui/app_spacing.dart';
import '../ui/app_typography.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message,
    this.size = AppSpacing.xl,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: const CircularProgressIndicator(
                color: AppColors.seed,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
