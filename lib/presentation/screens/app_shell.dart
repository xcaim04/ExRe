import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../state/app_state.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_status_bar.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'gallery_screen.dart';
import 'home_screen.dart';
import 'progress_screen.dart';

/// Contenedor de las cinco pestañas.
///
/// Usa `IndexedStack` para conservar el estado de cada pestaña al cambiar de
/// una a otra. La barra inferior está presente en Inicio, Catálogo, Galería,
/// Favoritos y Progreso; el Detalle se apila encima y no la muestra.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialTab = AppTab.home});

  final AppTab initialTab;

  @override
  State<AppShell> createState() => AppShellState();

  /// Permite a los hijos pedir un cambio de pestaña (accesos rápidos).
  static AppShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<AppShellState>();
}

class AppShellState extends State<AppShell> {
  late AppTab _tab = widget.initialTab;

  void selectTab(AppTab tab) {
    if (_tab == tab) return;
    setState(() => _tab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // La carga inicial se dispara desde `main()`; aquí solo reflejamos estado.
    final state = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: state.isLoading
          ? const _LoadingView()
          : SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const AppStatusBar(),
                  Expanded(
                    child: IndexedStack(
                      index: _tab.index,
                      children: const [
                        HomeScreen(),
                        CatalogScreen(),
                        GalleryScreen(),
                        FavoritesScreen(),
                        ProgressScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNav(current: _tab, onChanged: selectTab),
    );
  }
}

/// Estado de carga inicial, con el fondo de la app.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.bg,
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
        ),
      ),
    );
  }
}
