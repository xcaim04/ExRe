import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/resource.dart';

/// Tarjeta de recurso en rejilla (Galería).
///
/// Ancho 171, `cornerRadius: 16`, `stroke: colorBorder`, `clip: true`
/// (imprescindible para que el badge no se salga de la tarjeta).
/// Cover de `height: 100` en el color de la categoría; body con
/// `padding: 10` y `gap: 4`.
class ResourceGridCard extends StatelessWidget {
  const ResourceGridCard({
    required this.resource,
    super.key,
    this.onTap,
    this.onToggleFavorite,
  });

  final Resource resource;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          // `clip: true` — sin esto el badge se sale de la tarjeta.
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: c.border, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GridCover(
                  resource: resource,
                  onToggleFavorite: onToggleFavorite,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body12.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 11, color: c.textTertiary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              resource.durationLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body11.copyWith(
                                color: c.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cover de altura 100 con el color de la categoría y el badge de favorito.
class _GridCover extends StatelessWidget {
  const _GridCover({required this.resource, required this.onToggleFavorite});

  final Resource resource;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: resource.category.color),
          Center(
            child: Text(
              resource.category.shortLabel,
              style: AppTypography.body15.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (resource.isCompleted)
            Positioned(
              top: 6,
              left: 6,
              child: _Badge(color: c.success, icon: Icons.check),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggleFavorite,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    resource.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18,
                    color: resource.isFavorite ? c.favorite : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge circular pequeño (completado).
class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 12, color: Colors.white),
    );
  }
}
