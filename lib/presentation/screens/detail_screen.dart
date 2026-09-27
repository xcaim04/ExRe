import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/resource.dart';
import '../state/app_state.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_status_bar.dart';

/// Pantalla de Detalle.
///
/// Se alcanza por `push` y se vuelve con el botón de la esquina. No muestra la
/// barra inferior: se llega por navegación, no por pestañas.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = AppStateScope.of(context);
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    final resource = id == null ? null : state.resourceById(id);

    if (resource == null) {
      return Scaffold(
        backgroundColor: c.bg,
        body: Column(
          children: [
            const AppStatusBar(),
            Expanded(
              child: Center(
                child: Text(
                  'Recurso no encontrado',
                  style: AppTypography.body14.copyWith(color: c.textSecondary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppStatusBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  0,
                  AppSpacing.screenH,
                  AppSpacing.xl,
                ),
                children: [
                  _BackBar(
                    title: resource.category.value,
                    isFavorite: resource.isFavorite,
                    onToggleFavorite: () => state.toggleFavorite(resource.id),
                  ),
                  const SizedBox(height: 16),
                  _Hero(resource: resource),
                  const SizedBox(height: 20),
                  Text(
                    resource.title,
                    style: AppTypography.display18.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: c.textTertiary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          resource.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body12.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MetaGrid(resource: resource),
                  const SizedBox(height: 20),
                  Text(
                    'Descripción',
                    style: AppTypography.display16.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.description,
                    style: AppTypography.body14Regular.copyWith(
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (resource.isCompleted)
                    SecondaryButton(
                      label: 'Marcar como pendiente',
                      icon: Icons.undo,
                      onPressed: () => state.toggleCompleted(resource.id),
                    )
                  else
                    PrimaryButton(
                      label: 'Marcar como completado',
                      icon: Icons.check,
                      onPressed: () => state.toggleCompleted(resource.id),
                    ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: resource.isFavorite
                        ? 'Quitar de favoritos'
                        : 'Añadir a favoritos',
                    icon: resource.isFavorite
                        ? Icons.favorite_border
                        : Icons.favorite,
                    onPressed: () => state.toggleFavorite(resource.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra superior del detalle: botón de volver y favorito.
class _BackBar extends StatelessWidget {
  const _BackBar({
    required this.title,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final String title;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(AppRadius.tab),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, size: 20, color: c.textPrimary),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.display16.copyWith(color: c.textPrimary),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggleFavorite,
            borderRadius: BorderRadius.circular(AppRadius.tab),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isFavorite ? c.favorite : c.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Portada grande con el color de la categoría.
class _Hero extends StatelessWidget {
  const _Hero({required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: resource.category.color,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Text(
        resource.category.value,
        style: AppTypography.display22.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Duración, tipo y nivel, en tarjetas de ancho flexible.
class _MetaGrid extends StatelessWidget {
  const _MetaGrid({required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget tile(IconData icon, String value, String label) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: c.textSecondary),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body14.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body11.copyWith(color: c.textTertiary),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tile(Icons.schedule, resource.durationLabel, 'Duración'),
        const SizedBox(width: 12),
        tile(_typeIcon(resource), resource.type.label, 'Tipo'),
        const SizedBox(width: 12),
        tile(Icons.signal_cellular_alt, resource.level.label, 'Nivel'),
      ],
    );
  }

  IconData _typeIcon(Resource r) => switch (r.type) {
    ResourceType.video => Icons.play_circle_outline,
    ResourceType.lectura => Icons.article_outlined,
    ResourceType.practica => Icons.code,
    ResourceType.documento => Icons.description_outlined,
  };
}
