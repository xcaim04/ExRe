import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

/// Carga únicamente los recursos marcados como favoritos.
class GetFavorites {
  const GetFavorites(this._repository);

  final ResourceRepository _repository;

  Future<List<Resource>> call() => _repository.getFavorites();
}
