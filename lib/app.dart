import 'package:flutter/material.dart';

import 'core/theme/app_colors_theme.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/app_shell.dart';
import 'presentation/screens/detail_screen.dart';
import 'presentation/widgets/app_bottom_nav.dart';
import 'presentation/state/app_state.dart';

/// Rutas nombradas de la app.
///
/// Un solo mecanismo de navegación en todo el proyecto: `Navigator.pushNamed`
/// con `onGenerateRoute`. No se mezcla con `go_router` ni con `Navigator.push`
/// directo.
abstract final class AppRoutes {
  static const String home = '/';
  static const String catalog = '/catalog';
  static const String gallery = '/gallery';
  static const String favorites = '/favorites';
  static const String progress = '/progress';
  static const String detail = '/detail';

  static const String _detailPrefix = '$detail/';

  /// Ruta de detalle con el id embebido: `/detail/flt-01`.
  static String detailOf(String resourceId) => '$_detailPrefix$resourceId';

  /// Colapsa `/detail/<id>` a `/detail` para que el generador de rutas
  /// resuelva por igual la ruta base y la ruta con id.
  static String? normalize(Object? name) {
    if (name is! String) return null;
    return name.startsWith(_detailPrefix) ? detail : name;
  }

  /// Extrae el id del recurso de una ruta de detalle: `/detail/flt-01` -> `flt-01`.
  ///
  /// Devuelve `null` si la ruta no es de detalle o no trae id.
  static String? resourceIdFromRoute(Object? name) {
    if (name is! String) return null;
    if (!name.startsWith(_detailPrefix)) return null;
    final id = name.substring(_detailPrefix.length);
    return id.isEmpty ? null : id;
  }

  /// Lee el id del recurso de los `arguments` con los que se empuja la ruta.
  ///
  /// Todos los screens empujan `arguments: resource.id`, que es de donde
  /// [DetailScreen] obtiene el recurso.
  static String? resourceIdOf(Object? arguments) {
    if (arguments is! String) return null;
    final id = arguments.trim();
    return id.isEmpty ? null : id;
  }
}

class ExreApp extends StatelessWidget {
  const ExreApp({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: state,
      child: MaterialApp(
        title: 'ExRE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        initialRoute: AppRoutes.home,
        onGenerateRoute: generateRoute,
      ),
    );
  }

  /// Generador de rutas. Público para poder reutilizarlo en pruebas.
  @visibleForTesting
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // `/detail` y `/detail/<id>` resuelven a la misma pantalla.
    final route = AppRoutes.normalize(settings.name);

    // Las cinco pestañas comparten `AppShell` (IndexedStack + barra inferior),
    // de modo que cambiar de pestaña conserva el estado de cada una.
    final Widget screen = switch (route) {
      AppRoutes.home => const AppShell(initialTab: AppTab.home),
      AppRoutes.catalog => const AppShell(initialTab: AppTab.catalog),
      AppRoutes.gallery => const AppShell(initialTab: AppTab.gallery),
      AppRoutes.favorites => const AppShell(initialTab: AppTab.favorites),
      AppRoutes.progress => const AppShell(initialTab: AppTab.progress),
      AppRoutes.detail => const DetailScreen(),
      _ => const _NotFoundScreen(),
    };

    // El diseño no define animaciones de transición entre pantallas.
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, _, _) => screen,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}

/// Pantalla de respaldo para rutas desconocidas.
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Ruta no encontrada',
          style: AppTypography.body14.copyWith(color: c.textSecondary),
        ),
      ),
    );
  }
}
