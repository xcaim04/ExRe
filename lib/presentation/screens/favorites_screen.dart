import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/resource_list_card.dart';
import 'catalog_screen.dart';

/// Pantalla de Favoritos.
///
/// Usa `ListView.separated` con separadores visuales, a diferencia del
/// Catálogo, que usa `ListView.builder`.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = AppStateScope.of(context);
    final favorites = state.filteredFavorites;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            0,
            AppSpacing.screenH,
            12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Favoritos',
                  style: AppTypography.display22.copyWith(color: c.textPrimary),
                ),
              ),
              Text(
                '${favorites.length}',
                style: AppTypography.display18.copyWith(color: c.favorite),
              ),
            ],
          ),
        ),
        CategoryFilterBar(state: state),
        const SizedBox(height: 12),
        Expanded(
          child: favorites.isEmpty
              ? EmptyState(
                  icon: Icons.favorite_border,
                  message: state.hasActiveFilters
                      ? 'Ningún favorito coincide con los filtros activos.'
                      : 'Todavía no has marcado ningún recurso como favorito.',
                  actionLabel: state.hasActiveFilters
                      ? 'Limpiar filtros'
                      : null,
                  onAction: state.clearFilters,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    0,
                    AppSpacing.screenH,
                    AppSpacing.xl,
                  ),
                  itemCount: favorites.length,
                  separatorBuilder: (context, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Divider(color: c.border, thickness: 1),
                  ),
                  itemBuilder: (context, index) {
                    final resource = favorites[index];
                    return ResourceListCard(
                      resource: resource,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.detailOf(resource.id),
                        arguments: resource.id,
                      ),
                      onToggleFavorite: () => state.toggleFavorite(resource.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
