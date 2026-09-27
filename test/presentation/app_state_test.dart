import 'package:exre/core/constants/categories.dart';
import 'package:exre/core/di/injection.dart';
import 'package:exre/domain/entities/lifecycle_event.dart';
import 'package:exre/presentation/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// AppState necesita un [Injection] completo. Para estas pruebas solo se
/// ejercitan los casos de uso puros (`GetProgressStats`) y la lógica de
/// filtrado en memoria, que no toca SQLite.
void main() {
  group('AppState: filtros y búsqueda', () {
    late AppState state;

    setUp(() {
      // `Injection.build()` no abre la base hasta que se le pide un dato, así
      // que es seguro construirlo sin `sqflite` inicializado.
      state = AppState(Injection.build());
    });

    test('arranca sin filtros activos', () {
      expect(state.hasActiveFilters, isFalse);
      expect(state.categoryFilter, isNull);
      expect(state.searchQuery, isEmpty);
    });

    test('activar y desactivar un filtro de categoría', () {
      state.toggleCategoryFilter(ResourceCategory.flutter);
      expect(state.categoryFilter, ResourceCategory.flutter);
      expect(state.hasActiveFilters, isTrue);

      // Un segundo toque sobre la misma categoría la deselecciona.
      state.toggleCategoryFilter(ResourceCategory.flutter);
      expect(state.categoryFilter, isNull);
      expect(state.hasActiveFilters, isFalse);
    });

    test('la búsqueda activa el estado de filtros', () {
      state.setSearchQuery('flutter');

      expect(state.searchQuery, 'flutter');
      expect(state.hasActiveFilters, isTrue);
    });

    test('clearFilters limpia categoría y búsqueda', () {
      state.toggleCategoryFilter(ResourceCategory.slivers);
      state.setSearchQuery('grid');

      state.clearFilters();

      expect(state.categoryFilter, isNull);
      expect(state.searchQuery, isEmpty);
      expect(state.hasActiveFilters, isFalse);
    });

    test('los eventos de ciclo de vida se acumulan en memoria', () {
      expect(state.lifecycleLog, isEmpty);

      state.onLifecycleEvent(
        LifecycleEvent(
          state: LifecycleState.paused,
          timestamp: DateTime(2026, 1, 1, 10, 30, 15),
        ),
      );
      state.onLifecycleEvent(
        LifecycleEvent(
          state: LifecycleState.resumed,
          timestamp: DateTime(2026, 1, 1, 10, 31, 0),
        ),
      );

      expect(state.lifecycleLog, hasLength(2));
      // El más reciente va primero.
      expect(state.lifecycleLog.first.state, LifecycleState.resumed);
      expect(state.currentLifecycle, LifecycleState.resumed);
    });

    test('el log de ciclo de vida respeta el máximo', () {
      for (var i = 0; i < AppState.maxLifecycleLog + 5; i++) {
        state.onLifecycleEvent(
          LifecycleEvent(
            state: LifecycleState.inactive,
            timestamp: DateTime(2026, 1, 1, 10, 0, i),
          ),
        );
      }

      expect(state.lifecycleLog, hasLength(AppState.maxLifecycleLog));
    });

    test('notifica a los escuchantes al cambiar un filtro', () {
      var notifications = 0;
      state.addListener(() => notifications++);

      state.setSearchQuery('a');
      state.setSearchQuery('a'); // sin cambio: no notifica
      state.setSearchQuery('ab');

      expect(notifications, 2);
    });
  });
}
