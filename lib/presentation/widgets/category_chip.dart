import 'package:flutter/material.dart';

import '../../core/constants/categories.dart';
import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Chip de filtro por categoría.
///
/// `cornerRadius: 20` (pill), `padding: [8, 14]`, `stroke: colorBorder`,
/// `fill: colorSurface`, label `Inter 12px 500` en `colorTextSecondary`.
/// Seleccionado: fondo = color de la categoría, texto blanco.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  final ResourceCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final background = isSelected ? category.color : c.surface;
    final border = isSelected ? category.color : c.border;
    final foreground = isSelected ? Colors.white : c.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: border, width: 1),
          ),
          child: Text(
            category.value,
            style: AppTypography.body12.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
