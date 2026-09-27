import '../../core/constants/categories.dart';
import '../../core/di/injection.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/entities/lifecycle_event.dart';
import 'package:flutter/widgets.dart';
import '../../domain/entities/resource.dart';
import '../../domain/usecases/get_progress_stats.dart';

/// Estado central de la aplicación.
///
/// `ChangeNotifier` puro del SDK, expuesto a los widgets mediante
/// [AppStateScope] (un `InheritedNotifier`). Contiene los recursos, los
/// filtros, la búsqueda y el historial de ciclo de vida.
class AppState extends ChangeNotifier {
  AppState(this._di);

  final Injection _di;

  // ---------------------------------------------------------------------
  // Datos
  // ---------------------------------------------------------------------
  List<Resource> _resources = const [];
  bool _isLoading = true;
  String? _error;

  // ---------------------------------------------------------------------
  // Filtros y búsqueda
  // ---------------------------------------------------------------------
  ResourceCategory? _categoryFilter;
  String _searchQuery = '';

  // ---------------------------------------------------------------------
  // Ciclo de vida
  // ---------------------------------------------------------------------
  final List<LifecycleEvent> _lifecycleLog = [];
  LifecycleState _currentLifecycle = LifecycleState.resumed;

  /// Máximo de eventos guardados en memoria.
  static const int maxLifecycleLog = 8;

  // ---------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------

  bool get isLoading => _isLoading;

  String? get error => _error;

  /// Todos los recursos, sin filtrar.
  List<Resource> get allResources => _resources;

  /// Categoría seleccionada en los filtros (`null` = todas).
  ResourceCategory? get categoryFilter => _categoryFilter;

  String get searchQuery => _searchQuery;

  bool get hasActiveFilters =>
      _categoryFilter != null || _searchQuery.isNotEmpty;

  /// Eventos de ciclo de vida, del más reciente al más antiguo.
  List<LifecycleEvent> get lifecycleLog => List.unmodifiable(_lifecycleLog);

  LifecycleState get currentLifecycle => _currentLifecycle;

  /// Etiqueta legible del estado actual, p. ej. `Foreground`.
  String get lifecycleLabel => _currentLifecycle.label;

  /// El recurso está en favoritos.
  bool isFavorite(String id) =>
      _resources.where((r) => r.id == id).firstOrNull?.isFavorite ?? false;

  /// El recurso está completado.
  bool isCompleted(String id) =>
      _resources.where((r) => r.id == id).firstOrNull?.isCompleted ?? false;

  /// Un recurso por id, o `null` si no existe.
  Resource? resourceById(String id) =>
      _resources.where((r) => r.id == id).firstOrNull;

  /// Catálogo con los filtros de categoría y búsqueda aplicados.
  ///
  /// El filtrado ocurre en memoria sobre la lista ya cargada, de modo que la
  /// respuesta es inmediata y no depende de un segundo viaje a SQLite.
  List<Resource> get filteredResources => _apply(_resources);

  /// Favoritos, respetando categoría y búsqueda.
  List<Resource> get filteredFavorites {
    final favorites = _resources.where((r) => r.isFavorite).toList();
    return _apply(favorites);
  }

  /// Estadísticas de progreso del conjunto completo.
  ProgressStats get progressStats => _di.getProgressStats(_resources);

  /// Estadísticas de progreso de la selección filtrada actual.
  ProgressStats get filteredProgressStats =>
      _di.getProgressStats(filteredResources);

  /// Categorías que tienen al menos un recurso.
  List<ResourceCategory> get availableCategories {
    final present = _resources.map((r) => r.category).toSet();
    return ResourceCategory.values
        .where(present.contains)
        .toList(growable: false);
  }

  List<Resource> _apply(List<Resource> source) {
    final query = _searchQuery.trim().toLowerCase();
    return source
        .where((r) {
          if (_categoryFilter != null && r.category != _categoryFilter) {
            return false;
          }
          if (query.isEmpty) return true;
          return r.title.toLowerCase().contains(query) ||
              r.author.toLowerCase().contains(query) ||
              r.description.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  // ---------------------------------------------------------------------
  // Acciones
  // ---------------------------------------------------------------------

  /// Carga inicial: siembra la base si hace falta y lee los recursos.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final repo = _di.repository;
      if (repo is ResourceRepositoryImpl) {
        await repo.seedIfEmpty();
      }
      _resources = await _di.getAllResources();
    } catch (e) {
      _error = 'No se pudieron cargar los recursos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selecciona una categoría, o `null` para ver todas.
  void setCategoryFilter(ResourceCategory? category) {
    if (_categoryFilter == category) return;
    _categoryFilter = category;
    notifyListeners();
  }

  /// Alterna entre "todas" y la categoría dada.
  void toggleCategoryFilter(ResourceCategory category) =>
      setCategoryFilter(_categoryFilter == category ? null : category);

  /// Actualiza el texto de búsqueda.
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  /// Limpia búsqueda y categoría.
  void clearFilters() {
    if (!hasActiveFilters) return;
    _categoryFilter = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Alterna el favorito y propaga el cambio a todas las pantallas.
  Future<void> toggleFavorite(String id) async {
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) return;

    // Actualización optimista: la UI responde al instante.
    final previous = _resources[index];
    _resources = List.of(_resources)
      ..[index] = previous.copyWith(isFavorite: !previous.isFavorite);
    notifyListeners();

    final saved = await _di.toggleFavorite(id);
    _applyPersisted(id, isFavorite: saved);
  }

  /// Alterna el completado y propaga el cambio a todas las pantallas.
  Future<void> toggleCompleted(String id) async {
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final previous = _resources[index];
    _resources = List.of(_resources)
      ..[index] = previous.copyWith(isCompleted: !previous.isCompleted);
    notifyListeners();

    final saved = await _di.toggleCompleted(id);
    _applyPersisted(id, isCompleted: saved);
  }

  /// Sincroniza el estado en memoria con lo que quedó persistido.
  void _applyPersisted(String id, {bool? isFavorite, bool? isCompleted}) {
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final current = _resources[index];
    final updated = current.copyWith(
      isFavorite: isFavorite,
      isCompleted: isCompleted,
    );
    if (updated == current) return;

    _resources = List.of(_resources)..[index] = updated;
    notifyListeners();
  }

  /// Registra un evento de ciclo de vida observado en tiempo real.
  void onLifecycleEvent(LifecycleEvent event) {
    _currentLifecycle = event.state;
    _lifecycleLog.insert(0, event);
    if (_lifecycleLog.length > maxLifecycleLog) {
      _lifecycleLog.removeRange(maxLifecycleLog, _lifecycleLog.length);
    }
    notifyListeners();
  }
}

/// Expone [AppState] al árbol de widgets de forma reactiva.
///
/// `InheritedNotifier` del SDK: los widgets que llaman a
/// `AppStateScope.of(context)` se reconstruyen solos cuando el estado cambia.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState state,
    required super.child,
    super.key,
  }) : super(notifier: state);

  /// Acceso al estado. Lanza si el scope no está en el árbol.
  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(
      scope != null,
      'AppStateScope no encontrado en el árbol de widgets.',
    );
    return scope!.notifier!;
  }

  /// Acceso al estado sin establecer dependencia (para callbacks).
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppStateScope>();
    assert(
      scope != null,
      'AppStateScope no encontrado en el árbol de widgets.',
    );
    return scope!.notifier!;
  }
}
