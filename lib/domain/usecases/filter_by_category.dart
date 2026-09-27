import '../../core/constants/categories.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

/// Filtra recursos por categoría. `null` devuelve todas.
class FilterByCategory {
  const FilterByCategory(this._repository);

  final ResourceRepository _repository;

  Future<List<Resource>> call(ResourceCategory? category) =>
      _repository.filterByCategory(category);
}
