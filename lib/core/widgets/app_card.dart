import 'package:flutter/material.dart';

import '../ui/app_colors.dart';
import '../ui/app_radius.dart';
import '../ui/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.margin,
    this.onTap,
    this.highlighted = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = highlighted
        ? colorScheme.primary.withValues(alpha: 0.55)
        : colorScheme.outlineVariant.withValues(alpha: 0.6);
    final shadowColor = highlighted
        ? colorScheme.primary.withValues(alpha: 0.18)
        : AppColors.seed.withValues(alpha: 0.08);
    final borderWidth = highlighted ? 1.4 : 1.0;
    final blurRadius = highlighted ? AppSpacing.md : AppSpacing.sm;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: blurRadius,
            offset: const Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: onTap == null
          ? Padding(
              padding: padding,
              child: child,
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadius.lg,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
    );
  }
}
