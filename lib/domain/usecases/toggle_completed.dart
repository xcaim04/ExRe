import '../repositories/resource_repository.dart';

/// Alterna el completado de un recurso y devuelve el nuevo valor.
class ToggleCompleted {
  const ToggleCompleted(this._repository);

  final ResourceRepository _repository;

  Future<bool> call(String id) => _repository.toggleCompleted(id);
}
