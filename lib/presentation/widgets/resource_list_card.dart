import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/resource.dart';
import 'resource_cover.dart';

/// Tarjeta de recurso en lista (Catálogo y Favoritos).
///
/// Ancho 358, `cornerRadius: 16`, `padding: 12`, `gap: 12`,
/// `stroke: colorBorder` width 1, `fill: colorSurface`, `alignItems: center`.
/// Cover 56x56 con `cornerRadius: 12`. Ícono de favorito 20x20.
class ResourceListCard extends StatelessWidget {
  const ResourceListCard({
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
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          width: 358,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border, width: 1),
          ),
          child: Row(
            children: [
              ResourceCover(category: resource.category),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body14.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: c.textTertiary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            resource.durationLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.body11.copyWith(
                              color: c.textTertiary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            resource.type.label,
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
              const SizedBox(width: 8),
              _FavoriteButton(
                isFavorite: resource.isFavorite,
                onTap: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ícono de favorito 20x20: `colorTextTertiary` inactivo, `colorFavorite` activo.
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: isFavorite ? c.favorite : c.textTertiary,
          ),
        ),
      ),
    );
  }
}
