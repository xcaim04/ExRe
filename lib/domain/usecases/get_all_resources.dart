import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

/// Carga todos los recursos del repositorio.
class GetAllResources {
  const GetAllResources(this._repository);

  final ResourceRepository _repository;

  Future<List<Resource>> call() => _repository.getAll();
}
