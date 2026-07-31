import 'package:flutter/material.dart';

class AppPageHeaderAction {
  const AppPageHeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final String tooltip;
  final String? semanticLabel;
  final VoidCallback onPressed;
}

class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions = const [],
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<AppPageHeaderAction> actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        (subtitle == null ? 68 : 82) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ) ??
        TextStyle(color: colorScheme.onSurfaceVariant);

    return AppBar(
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leadingWidth: showBackButton ? 72 : 0,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _HeaderActionButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Volver',
                onPressed: onBackPressed ?? () => Navigator.maybePop(context),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                hoverBackgroundColor: Color.alphaBlend(
                  colorScheme.onPrimaryContainer.withValues(alpha: 0.08),
                  colorScheme.primaryContainer,
                ),
                iconSize: 26,
                buttonSize: 40,
              ),
            )
          : null,
      titleSpacing: showBackButton ? 16 : 16,
      title: subtitle == null
          ? Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: subtitleStyle,
                ),
              ],
            ),
      actions: [
        for (final action in actions)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _HeaderActionButton(
              icon: action.icon,
              tooltip: action.tooltip,
              semanticLabel: action.semanticLabel,
              onPressed: action.onPressed,
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurfaceVariant,
              hoverBackgroundColor: Color.alphaBlend(
                colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
                colorScheme.surfaceContainerHighest,
              ),
              iconSize: 22,
              buttonSize: 40,
            ),
          ),
      ],
      bottom: bottom,
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.hoverBackgroundColor,
    required this.iconSize,
    required this.buttonSize,
    this.semanticLabel,
  });

  final IconData icon;
  final String tooltip;
  final String? semanticLabel;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color hoverBackgroundColor;
  final double iconSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: semanticLabel ?? tooltip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
            color: backgroundColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              hoverColor: hoverBackgroundColor,
              onTap: onPressed,
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: Icon(
                  icon,
                  color: foregroundColor,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}