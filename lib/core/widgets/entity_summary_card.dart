import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class EntitySummaryCard extends StatelessWidget {
  const EntitySummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.details,
    this.statusWidget,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final List<Widget>? details;
  final Widget? statusWidget;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDetails = details != null && details!.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (hasDetails) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ..._buildDetailsWithSpacing(details!),
                  ],
                  if (statusWidget != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    statusWidget!,
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailsWithSpacing(List<Widget> detailWidgets) {
    final result = <Widget>[];

    for (var i = 0; i < detailWidgets.length; i++) {
      if (i > 0) {
        result.add(const SizedBox(height: AppSpacing.xs));
      }
      result.add(detailWidgets[i]);
    }

    return result;
  }
}