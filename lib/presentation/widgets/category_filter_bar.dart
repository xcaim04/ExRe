import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../state/app_state.dart';
import 'category_chip.dart';

/// Barra horizontal de chips de categoría, usada en Catálogo y Favoritos.
///
/// Se apoya en el filtro global de [AppState], de modo que el estado se
/// conserva al cambiar de pestaña.
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: [
          for (final category in state.availableCategories) ...[
            CategoryChip(
              category: category,
              isSelected: state.categoryFilter == category,
              onTap: () => state.toggleCategoryFilter(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
