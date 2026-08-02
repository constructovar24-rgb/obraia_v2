import 'package:flutter/material.dart';

import '../ui/app_radius.dart';
import '../ui/app_spacing.dart';
import '../ui/app_typography.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final canPress = enabled && !loading;
    final resolvedOnPressed = canPress ? onPressed : null;

    Widget buildLabel() {
      if (!loading) {
        return Text(label);
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSpacing.md,
            height: AppSpacing.md,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    final button = icon == null
        ? FilledButton(
            onPressed: resolvedOnPressed,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              textStyle: textTheme.labelLarge,
            ),
            child: loading
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0,
                        child: buildLabel(),
                      ),
                      SizedBox(
                        width: AppSpacing.md,
                        height: AppSpacing.md,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                : buildLabel(),
          )
        : FilledButton.icon(
            onPressed: resolvedOnPressed,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              textStyle: textTheme.labelLarge,
            ),
            icon: loading
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0,
                        child: Icon(icon),
                      ),
                      SizedBox(
                        width: AppSpacing.md,
                        height: AppSpacing.md,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(icon),
            label: loading
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0,
                        child: Text(label),
                      ),
                      const SizedBox.shrink(),
                    ],
                  )
                : Text(label),
          );

    if (!expand) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
