import 'package:exre/core/constants/categories.dart';
import 'package:exre/domain/usecases/filter_by_category.dart';
import 'package:exre/domain/usecases/toggle_favorite.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_resource_repository.dart';

void main() {
  late FakeResourceRepository repository;
  late ToggleFavorite toggleFavorite;
  late FilterByCategory filterByCategory;

  setUp(() {
    repository = FakeResourceRepository();
    toggleFavorite = ToggleFavorite(repository);
    filterByCategory = FilterByCategory(repository);
  });

  group('ToggleFavorite', () {
    test('marca un recurso como favorito cuando no lo era', () async {
      final result = await toggleFavorite('a');

      expect(result, isTrue);
      expect(
        repository.items.firstWhere((r) => r.id == 'a').isFavorite,
        isTrue,
      );
    });

    test('desmarca un recurso que ya era favorito', () async {
      await toggleFavorite('a');
      final result = await toggleFavorite('a');

      expect(result, isFalse);
      expect(
        repository.items.firstWhere((r) => r.id == 'a').isFavorite,
        isFalse,
      );
    });

    test('no afecta a otros recursos', () async {
      await toggleFavorite('a');

      final b = repository.items.firstWhere((r) => r.id == 'b');
      final c = repository.items.firstWhere((r) => r.id == 'c');
      expect(b.isFavorite, isFalse);
      expect(c.isFavorite, isFalse);
    });

    test('devuelve false con un id inexistente', () async {
      final result = await toggleFavorite('no-existe');

      expect(result, isFalse);
    });
  });

  group('FilterByCategory', () {
    test('devuelve solo los recursos de la categoría', () async {
      final result = await filterByCategory(ResourceCategory.layouts);

      expect(result, hasLength(1));
      expect(result.single.id, 'b');
      expect(result.single.category, ResourceCategory.layouts);
    });

    test('devuelve todos los recursos con categoría null', () async {
      final result = await filterByCategory(null);

      expect(result, hasLength(3));
    });

    test('devuelve lista vacía para una categoría sin recursos', () async {
      final result = await filterByCategory(ResourceCategory.navegacion);

      expect(result, isEmpty);
    });
  });
}
