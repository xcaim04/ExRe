import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/category_chip.dart';
import '../widgets/quick_access_card.dart';
import '../widgets/resource_list_card.dart';
import '../widgets/stat_card.dart';
import 'app_shell.dart';

/// Pantalla de Inicio: resumen, accesos rápidos y estado del ciclo de vida.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = AppStateScope.of(context);
    final stats = state.progressStats;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.xl,
      ),
      children: [
        Text(
          'ExRE',
          style: AppTypography.display22.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Explorador de Recursos de Estudio',
          style: AppTypography.body14Regular.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: 20),

        // --------------------------------------------------------- Métricas
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: '${stats.total}',
                label: 'Recursos',
                icon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                value: '${stats.favorites}',
                label: 'Favoritos',
                icon: Icons.favorite,
                valueColor: c.favorite,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: '${stats.completed}',
                label: 'Completados',
                icon: Icons.check_circle,
                valueColor: c.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                value: '${stats.overallPercent}%',
                label: 'Progreso',
                icon: Icons.insights,
                valueColor: c.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ------------------------------------------------------ Accesos rápidos
        Text(
          'Accesos rápidos',
          style: AppTypography.display16.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              QuickAccessCard(
                title: 'Ver catálogo',
                icon: Icons.list_alt,
                onTap: () => AppShell.of(context)?.selectTab(AppTab.catalog),
              ),
              const SizedBox(width: 12),
              QuickAccessCard(
                title: 'Abrir galería',
                icon: Icons.grid_view,
                onTap: () => AppShell.of(context)?.selectTab(AppTab.gallery),
              ),
              const SizedBox(width: 12),
              QuickAccessCard(
                title: 'Mi progreso',
                icon: Icons.insights,
                onTap: () => AppShell.of(context)?.selectTab(AppTab.progress),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ------------------------------------------------------- Categorías
        Text(
          'Categorías',
          style: AppTypography.display16.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in state.availableCategories)
              CategoryChip(
                category: category,
                isSelected: state.categoryFilter == category,
                onTap: () => state.toggleCategoryFilter(category),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // ------------------------------------------------- Ciclo de vida
        Text(
          'Ciclo de vida',
          style: AppTypography.display16.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        _LifecyclePanel(state: state),
        const SizedBox(height: 20),

        // -------------------------------------------- Continuar donde quedó
        if (state.filteredResources.isNotEmpty) ...[
          Text(
            'Para empezar',
            style: AppTypography.display16.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 12),
          for (final resource in state.filteredResources.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ResourceListCard(
                resource: resource,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detailOf(resource.id),
                  arguments: resource.id,
                ),
                onToggleFavorite: () => state.toggleFavorite(resource.id),
              ),
            ),
          const SizedBox(height: 8),
          PrimaryButton(
            label: 'Ver todo el catálogo',
            icon: Icons.arrow_forward,
            onPressed: () => AppShell.of(context)?.selectTab(AppTab.catalog),
          ),
        ],
      ],
    );
  }
}

/// Estado actual del ciclo de vida y los últimos eventos observados.
class _LifecyclePanel extends StatelessWidget {
  const _LifecyclePanel({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final log = state.lifecycleLog;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: c.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Estado: ${state.lifecycleLabel}',
                  style: AppTypography.body14.copyWith(color: c.textPrimary),
                ),
              ),
              Text(
                '${log.length} evento${log.length == 1 ? '' : 's'}',
                style: AppTypography.body11.copyWith(color: c.textTertiary),
              ),
            ],
          ),
          if (log.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Sin eventos todavía. Cambia entre primer plano y segundo plano '
              'para verlos aparecer aquí.',
              style: AppTypography.body11.copyWith(color: c.textTertiary),
            ),
          ] else ...[
            const SizedBox(height: 12),
            for (final event in log.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      event.timeLabel,
                      style: AppTypography.body11.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      event.state.label,
                      style: AppTypography.body11.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
