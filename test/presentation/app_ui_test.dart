import 'package:exre/app.dart';
import 'package:exre/core/constants/categories.dart';
import 'package:exre/core/di/injection.dart';
import 'package:exre/core/theme/app_colors.dart';
import 'package:exre/core/theme/app_theme.dart';
import 'package:exre/presentation/state/app_state.dart';
import 'package:exre/presentation/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_resource_repository.dart';

/// Pruebas de humo de la UI: verifican tokens de fidelidad visual, navegación
/// por rutas nombradas y presencia/ausencia de la barra inferior.
void main() {
  late AppState state;

  setUp(() {
    // Se inyecta el fake para no depender de `sqflite` en las pruebas de UI.
    state = AppState(Injection.build(repository: FakeResourceRepository()));
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await state.load();
    await tester.pumpWidget(ExreApp(state: state));
    await tester.pump();
  }

  group('tokens del diseño', () {
    test('la paleta del tema coincide con la especificación', () {
      expect(AppColors.colorPrimary, const Color(0xFF4F46E5));
      expect(AppColors.colorPrimarySoft, const Color(0xFF3A32A0));
      expect(AppColors.colorBg, const Color(0xFF231C6B));
      expect(AppColors.colorSurface, const Color(0xFF2E2789));
      expect(AppColors.colorTextPrimary, const Color(0xFFFFFFFF));
      expect(AppColors.colorTextSecondary, const Color(0xFFC5BFEE));
      expect(AppColors.colorTextTertiary, const Color(0xFF948CCB));
      expect(AppColors.colorBorder, const Color(0xFF443BA5));
      expect(AppColors.colorSuccess, const Color(0xFF16A34A));
      expect(AppColors.colorWarning, const Color(0xFFF59E0B));
      expect(AppColors.colorDanger, const Color(0xFFEF4444));
      expect(AppColors.colorFavorite, const Color(0xFFF43F5E));
    });

    test('cada categoría tiene su color fuerte y su versión light', () {
      expect(ResourceCategory.flutter.color, const Color(0xFF0553B1));
      expect(ResourceCategory.android.color, const Color(0xFF1DA260));
      expect(ResourceCategory.layouts.color, const Color(0xFFF59E0B));
      expect(ResourceCategory.scrollables.color, const Color(0xFFDB2777));
      expect(ResourceCategory.slivers.color, const Color(0xFF7C3AED));
      expect(ResourceCategory.navegacion.color, const Color(0xFFDC2626));

      expect(ResourceCategory.flutter.lightColor, const Color(0xFF54C5F8));
      expect(ResourceCategory.slivers.lightColor, const Color(0xFFC4B5FD));
    });

    test('los radios siguen la regla 16 / 18-20 / 14', () {
      expect(AppRadius.card, 16);
      expect(AppRadius.button, 14);
      expect(AppRadius.chip, 20);
      expect(AppRadius.quickAccess, 18);
    });

    test('la tipografía usa Poppins para display e Inter para body', () {
      expect(AppTypography.display22.fontFamily, 'Poppins');
      expect(AppTypography.display22.fontSize, 22);
      expect(AppTypography.display22.fontWeight, FontWeight.w700);

      expect(AppTypography.body14.fontFamily, 'Inter');
      expect(AppTypography.body14.fontWeight, FontWeight.w600);
      expect(AppTypography.body11.fontWeight, FontWeight.w400);
    });

    test('el fondo del scaffold es colorBg, nunca blanco', () {
      final theme = AppTheme.dark;
      expect(theme.scaffoldBackgroundColor, AppColors.colorBg);
      expect(theme.brightness, Brightness.dark);
    });
  });

  group('navegación', () {
    testWidgets('la app arranca en Inicio con la barra inferior visible', (
      tester,
    ) async {
      await pumpApp(tester);

      expect(find.text('ExRE'), findsOneWidget);
      expect(find.text('Explorador de Recursos de Estudio'), findsOneWidget);
      expect(find.byType(AppBottomNav), findsOneWidget);
    });

    testWidgets('la barra inferior cambia de pestaña', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Galería'));
      // `pump` y no `pumpAndSettle`: el reloj del StatusBar usa un
      // Timer.periodic infinito, así que la vista nunca "asienta".
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text('Galería'), findsWidgets);
      expect(find.text('Accesos rápidos'), findsNothing);
    });

    testWidgets('todas las pestañas están presentes en la barra', (
      tester,
    ) async {
      await pumpApp(tester);

      for (final tab in AppTab.values) {
        expect(find.text(tab.label), findsWidgets, reason: tab.label);
      }
    });

    test('las rutas nombradas están definidas y son únicas', () {
      final routes = {
        AppRoutes.home,
        AppRoutes.catalog,
        AppRoutes.gallery,
        AppRoutes.favorites,
        AppRoutes.progress,
        AppRoutes.detail,
      };

      expect(routes, hasLength(6));
      expect(AppRoutes.detailOf('flt-01'), '/detail/flt-01');
    });

    group('normalización de la ruta de detalle', () {
      test('colapsa /detail/<id> a /detail', () {
        expect(AppRoutes.normalize('/detail/flt-01'), AppRoutes.detail);
        expect(AppRoutes.normalize('/detail/cat-04'), AppRoutes.detail);
      });

      test('deja intactas el resto de rutas', () {
        expect(AppRoutes.normalize(AppRoutes.home), AppRoutes.home);
        expect(AppRoutes.normalize(AppRoutes.catalog), AppRoutes.catalog);
        expect(AppRoutes.normalize(AppRoutes.progress), AppRoutes.progress);
      });

      test('extrae el id de una ruta de detalle', () {
        expect(AppRoutes.resourceIdFromRoute('/detail/flt-01'), 'flt-01');
        expect(AppRoutes.resourceIdFromRoute('/detail/'), isNull);
        expect(AppRoutes.resourceIdFromRoute('/catalog'), isNull);
        expect(AppRoutes.resourceIdFromRoute(null), isNull);
      });

      test('lee el id de los arguments', () {
        expect(AppRoutes.resourceIdOf('flt-01'), 'flt-01');
        expect(AppRoutes.resourceIdOf('  '), isNull);
        expect(AppRoutes.resourceIdOf(42), isNull);
      });
    });

    testWidgets('una ruta /detail/<id> abre el detalle, no la pantalla 404', (
      tester,
    ) async {
      await state.load();
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        AppStateScope(
          state: state,
          child: MaterialApp(
            navigatorKey: navigator,
            theme: AppTheme.dark,
            initialRoute: AppRoutes.home,
            onGenerateRoute: ExreApp.generateRoute,
          ),
        ),
      );
      await tester.pump();

      navigator.currentState!.pushNamed(
        AppRoutes.detailOf('a'),
        arguments: 'a',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text('Ruta no encontrada'), findsNothing);
      expect(find.text('Introducción a Flutter'), findsWidgets);
    });
  });
}
