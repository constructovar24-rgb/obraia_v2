import 'package:flutter/material.dart';

import '../../core/ui/app_spacing.dart';
import 'app_section_id.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.expanded,
  });

  final AppSectionId selected;
  final ValueChanged<AppSectionId> onSelected;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      child: Container(
        key: ValueKey(
          expanded ? 'side-navigation-expanded' : 'side-navigation-compact',
        ),
        width: expanded ? 248 : 76,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: colors.outlineVariant)),
        ),
        child: Column(
          children: [
            _Brand(expanded: expanded),
            Divider(height: 1, color: colors.outlineVariant),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: [
                  _group(context, 'GENERAL', const [AppSectionId.inicio]),
                  _group(context, 'GESTIÓN', const [
                    AppSectionId.expedientes,
                    AppSectionId.clientes,
                    AppSectionId.presupuestos,
                    AppSectionId.facturas,
                    AppSectionId.cobros,
                  ]),
                  _group(context, 'OPERACIONES', const [
                    AppSectionId.compras,
                    AppSectionId.proveedores,
                    AppSectionId.certificaciones,
                    AppSectionId.documentos,
                  ]),
                  _group(context, 'SISTEMA', const [
                    AppSectionId.administracion,
                    AppSectionId.configuracion,
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _group(
    BuildContext context,
    String label,
    List<AppSectionId> sections,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 6),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            )
          else
            const SizedBox(height: AppSpacing.xs),
          for (final section in sections)
            _NavigationItem(
              section: section,
              selected: selected == section,
              expanded: expanded,
              onTap: () => onSelected(section),
            ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.expanded});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 72,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: expanded ? 18 : 14),
        child: Row(
          mainAxisAlignment: expanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'OI',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (expanded) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OBRA IA',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Gestión de construcción',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.section,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  final AppSectionId section;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = selected
        ? colors.onSecondaryContainer
        : colors.onSurfaceVariant;
    final item = Padding(
      padding: EdgeInsets.symmetric(horizontal: expanded ? 10 : 8, vertical: 2),
      child: Material(
        color: selected ? colors.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('navigation-${section.name}'),
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: expanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (expanded) const SizedBox(width: 12),
                Icon(section.icon, size: 21, color: foreground),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: foreground),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return expanded ? item : Tooltip(message: section.label, child: item);
  }
}
