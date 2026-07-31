import 'package:flutter/material.dart';

enum StatusType {
  neutral,
  success,
  warning,
  error,
  info,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.icon,
  });

  final String label;
  final StatusType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _resolveColors(theme.colorScheme, type);

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: colors.foreground,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  _StatusChipColors _resolveColors(ColorScheme colorScheme, StatusType type) {
    switch (type) {
      case StatusType.neutral:
        return _StatusChipColors(
          background: colorScheme.surfaceContainerHighest,
          foreground: colorScheme.onSurfaceVariant,
        );
      case StatusType.success:
        return _StatusChipColors(
          background: colorScheme.primaryContainer,
          foreground: colorScheme.onPrimaryContainer,
        );
      case StatusType.warning:
        return _StatusChipColors(
          background: colorScheme.tertiaryContainer,
          foreground: colorScheme.onTertiaryContainer,
        );
      case StatusType.error:
        return _StatusChipColors(
          background: colorScheme.errorContainer,
          foreground: colorScheme.onErrorContainer,
        );
      case StatusType.info:
        return _StatusChipColors(
          background: colorScheme.secondaryContainer,
          foreground: colorScheme.onSecondaryContainer,
        );
    }
  }
}

class _StatusChipColors {
  const _StatusChipColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}