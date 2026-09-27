import '../../core/constants/categories.dart';
import '../../domain/entities/resource.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/resource_local_datasource.dart';
import '../datasources/seed_resources.dart';

/// Implementación de [ResourceRepository] sobre SQLite.
///
/// En el primer arranque siembra la tabla desde `seed_resources.dart`
/// (cuando `COUNT(*) == 0`). A partir de ahí, todas las lecturas y
/// escrituras van contra la base local.
class ResourceRepositoryImpl implements ResourceRepository {
  ResourceRepositoryImpl(this._datasource);

  final ResourceLocalDataSource _datasource;

  bool _seeded = false;

  /// Siembra los recursos iniciales si la tabla está vacía.
  Future<void> seedIfEmpty() async {
    if (_seeded) return;
    _seeded = true;
    if (await _datasource.count() == 0) {
      await _datasource.insertAll(seedResources);
    }
  }

  @override
  Future<List<Resource>> getAll() => _datasource.getAll();

  @override
  Future<List<Resource>> getFavorites() => _datasource.getFavorites();

  @override
  Future<List<Resource>> search(String query) => _datasource.search(query);

  @override
  Future<List<Resource>> filterByCategory(ResourceCategory? category) =>
      _datasource.filterByCategory(category?.value);

  @override
  Future<bool> toggleFavorite(String id) async =>
      await _datasource.toggleFavorite(id) == 1;

  @override
  Future<bool> toggleCompleted(String id) async =>
      await _datasource.toggleCompleted(id) == 1;
}
