import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/app_buttons.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/resource_list_card.dart';

/// Pantalla de Catálogo: búsqueda, filtro por categoría y lista completa.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catálogo',
                style: AppTypography.display22.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 12),
              _SearchField(
                controller: _controller,
                onChanged: state.setSearchQuery,
              ),
            ],
          ),
        ),
        CategoryFilterBar(state: state),
        const SizedBox(height: 12),
        Expanded(
          child: resources.isEmpty
              ? EmptyState(
                  message: state.hasActiveFilters
                      ? 'Ningún recurso coincide con tu búsqueda.'
                      : 'Todavía no hay recursos.',
                  actionLabel: state.hasActiveFilters
                      ? 'Limpiar filtros'
                      : null,
                  onAction: state.clearFilters,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    0,
                    AppSpacing.screenH,
                    AppSpacing.xl,
                  ),
                  itemCount: resources.length,
                  itemBuilder: (context, index) {
                    final resource = resources[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ResourceListCard(
                        resource: resource,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.detailOf(resource.id),
                          arguments: resource.id,
                        ),
                        onToggleFavorite: () =>
                            state.toggleFavorite(resource.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Campo de búsqueda: `InputDecoration` sin marco, con `colorSurface` de fondo.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.body14.copyWith(color: c.textPrimary),
      cursorColor: c.primary,
      decoration: InputDecoration(
        hintText: 'Buscar por título, autor o descripción',
        hintStyle: AppTypography.body12.copyWith(color: c.textTertiary),
        prefixIcon: Icon(Icons.search, size: 20, color: c.textTertiary),
        suffixIcon: Icon(Icons.tune, size: 20, color: c.textTertiary),
        filled: true,
        fillColor: c.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: c.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: c.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: c.primary, width: 1),
        ),
      ),
    );
  }
}

/// Estado vacío reutilizable por las pantallas con listas.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: c.textTertiary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body12.copyWith(color: c.textSecondary),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              SecondaryButton(
                label: actionLabel!,
                icon: Icons.close,
                expand: false,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
