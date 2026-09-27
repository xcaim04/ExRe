import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

/// Busca recursos por texto libre (título, autor o descripción).
///
/// Una consulta vacía o solo con espacios devuelve la lista completa.
class SearchResources {
  const SearchResources(this._repository);

  final ResourceRepository _repository;

  Future<List<Resource>> call(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return _repository.getAll();
    return _repository.search(trimmed);
  }
}
