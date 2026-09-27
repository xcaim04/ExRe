import '../repositories/resource_repository.dart';

/// Alterna el favorito de un recurso y devuelve el nuevo valor.
class ToggleFavorite {
  const ToggleFavorite(this._repository);

  final ResourceRepository _repository;

  Future<bool> call(String id) => _repository.toggleFavorite(id);
}
