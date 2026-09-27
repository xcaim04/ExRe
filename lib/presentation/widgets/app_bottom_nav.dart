import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Las cinco pestañas de la app.
enum AppTab {
  home('Inicio', Icons.home_outlined, Icons.home),
  catalog('Catálogo', Icons.list_alt_outlined, Icons.list_alt),
  gallery('Galería', Icons.grid_view_outlined, Icons.grid_view),
  favorites('Favoritos', Icons.favorite_border, Icons.favorite),
  progress('Progreso', Icons.insights_outlined, Icons.insights);

  const AppTab(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Barra de navegación inferior.
///
/// Ícono en contenedor con `cornerRadius: 14`, `padding: 6`; label
/// `Inter 10px 500`. El tab activo usa `colorPrimary` / blanco.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final AppTab current;
  final ValueChanged<AppTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(top: BorderSide(color: c.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              for (final tab in AppTab.values)
                Expanded(
                  child: _TabItem(
                    tab: tab,
                    isActive: tab == current,
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Un ítem de la barra: ícono contenedor + label, layout vertical, gap 2.
class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final AppTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final iconColor = isActive ? Colors.white : c.textTertiary;
    final labelColor = isActive ? c.primary : c.textTertiary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.tab),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive ? c.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.tab),
                ),
                child: Icon(
                  isActive ? tab.activeIcon : tab.icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body10.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
