import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/resource_grid_card.dart';
import 'catalog_screen.dart';

/// Pantalla de Galería: rejilla de 2 columnas.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = AppStateScope.of(context);
    final resources = state.filteredResources;

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
                  'Galería',
                  style: AppTypography.display22.copyWith(color: c.textPrimary),
                ),
              ),
              Text(
                '${resources.length} recurso${resources.length == 1 ? '' : 's'}',
                style: AppTypography.body12.copyWith(color: c.textTertiary),
              ),
            ],
          ),
        ),
        CategoryFilterBar(state: state),
        const SizedBox(height: 12),
        Expanded(
          child: resources.isEmpty
              ? const EmptyState(message: 'No hay recursos para mostrar.')
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    0,
                    AppSpacing.screenH,
                    AppSpacing.xl,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    // 171 de ancho con cover de 100 + body de 10/10: la
                    // relación evita que las tarjetas se deformen.
                    childAspectRatio: 171 / 190,
                  ),
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    final resource = resources[index];
                    return ResourceGridCard(
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
