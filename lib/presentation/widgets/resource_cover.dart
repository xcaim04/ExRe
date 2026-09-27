import 'package:flutter/material.dart';

import '../../core/constants/categories.dart';
import '../../core/theme/app_theme.dart';

/// Portada de un recurso: bloque de color con las iniciales de la categoría.
///
/// El color de fondo es siempre el token fuerte de la categoría, el mismo que
/// usan los chips seleccionados y los puntos del breakdown de progreso.
class ResourceCover extends StatelessWidget {
  const ResourceCover({
    required this.category,
    super.key,
    this.size = 56,
    this.radius = AppRadius.cover,
  });

  final ResourceCategory category;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        category.shortLabel,
        style: AppTypography.body10.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
