import '../../data/datasources/resource_local_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/repositories/resource_repository.dart';
import '../../domain/usecases/filter_by_category.dart';
import '../../domain/usecases/get_all_resources.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/get_progress_stats.dart';
import '../../domain/usecases/search_resources.dart';
import '../../domain/usecases/toggle_completed.dart';
import '../../domain/usecases/toggle_favorite.dart';

/// Inyección de dependencias manual.
///
/// Solo el SDK de Flutter: sin `get_it`, sin `provider`, sin singletons
/// globales. Se construye una única vez desde `main()` y se pasa
/// explícitamente a la app.
class Injection {
  Injection._({
    required this.datasource,
    required this.repository,
    required this.getAllResources,
    required this.getFavorites,
    required this.searchResources,
    required this.filterByCategory,
    required this.toggleFavorite,
    required this.toggleCompleted,
    required this.getProgressStats,
  });

  /// Construye el grafo completo de dependencias.
  ///
  /// [repository] permite inyectar una implementación alternativa (por ejemplo
  /// un fake en pruebas) sin cambiar el resto del grafo.
  factory Injection.build({
    String databaseName = 'exre.db',
    ResourceRepository? repository,
  }) {
    final datasource = ResourceLocalDataSource(databaseName: databaseName);
    final repo = repository ?? ResourceRepositoryImpl(datasource);

    return Injection._(
      datasource: datasource,
      repository: repo,
      getAllResources: GetAllResources(repo),
      getFavorites: GetFavorites(repo),
      searchResources: SearchResources(repo),
      filterByCategory: FilterByCategory(repo),
      toggleFavorite: ToggleFavorite(repo),
      toggleCompleted: ToggleCompleted(repo),
      getProgressStats: const GetProgressStats(),
    );
  }

  final ResourceLocalDataSource datasource;
  final ResourceRepository repository;
  final GetAllResources getAllResources;
  final GetFavorites getFavorites;
  final SearchResources searchResources;
  final FilterByCategory filterByCategory;
  final ToggleFavorite toggleFavorite;
  final ToggleCompleted toggleCompleted;
  final GetProgressStats getProgressStats;
}
