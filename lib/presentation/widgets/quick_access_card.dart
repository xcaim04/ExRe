import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Tarjeta de acceso rápido de Inicio.
///
/// Ancho 170, `cornerRadius: 18`, `padding: 16`, `gap: 20`, fondo
/// `colorPrimary` sólido, label blanco `Inter 15px 600`.
class QuickAccessCard extends StatelessWidget {
  const QuickAccessCard({
    required this.title,
    required this.icon,
    super.key,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.quickAccess),
        child: Container(
          width: 170,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(AppRadius.quickAccess),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body15.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
