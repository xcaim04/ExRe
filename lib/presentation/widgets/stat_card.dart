import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Tarjeta de métrica para Inicio y Progreso.
///
/// Ancho mínimo 110, `cornerRadius: 16`, `padding: 14`, `gap: 2`,
/// `stroke: colorBorder`. Valor en `Poppins 22px 700`, label en
/// `Inter 11px 400` `colorTextSecondary`.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.value,
    required this.label,
    super.key,
    this.icon,
    this.valueColor,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: 110),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: valueColor ?? c.textSecondary),
            const SizedBox(height: 4),
          ],
          Text(
            value,
            style: AppTypography.display22.copyWith(
              color: valueColor ?? c.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body11.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
