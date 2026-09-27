import '../../core/constants/categories.dart';
import '../entities/resource.dart';

/// Filtro de categoría. `null` en [ResourceFilter.category] significa "todas".
class ResourceFilter {
  const ResourceFilter({this.category});

  static const ResourceFilter all = ResourceFilter();

  final ResourceCategory? category;

  ResourceFilter copyWith({ResourceCategory? category, bool clear = false}) =>
      ResourceFilter(category: clear ? null : category ?? this.category);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceFilter && other.category == category;

  @override
  int get hashCode => category.hashCode;
}

/// Contrato de persistencia de recursos.
abstract interface class ResourceRepository {
  /// Devuelve todos los recursos ordenados por título.
  Future<List<Resource>> getAll();

  /// Devuelve solo los favoritos.
  Future<List<Resource>> getFavorites();

  /// Busca por título, autor o descripción.
  Future<List<Resource>> search(String query);

  /// Filtra por categoría (o todas si [category] es `null`).
  Future<List<Resource>> filterByCategory(ResourceCategory? category);

  /// Alterna el favorito de un recurso y devuelve el estado resultante.
  Future<bool> toggleFavorite(String id);

  /// Alterna el completado de un recurso y devuelve el estado resultante.
  Future<bool> toggleCompleted(String id);
}
