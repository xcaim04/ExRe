import 'package:exre/core/constants/categories.dart';
import 'package:exre/domain/entities/resource.dart';
import 'package:exre/domain/repositories/resource_repository.dart';

/// Repositorio falso en memoria para probar los casos de uso sin SQLite.
class FakeResourceRepository implements ResourceRepository {
  FakeResourceRepository([List<Resource>? initial])
    : _items = List.of(initial ?? _defaultFixtures);

  final List<Resource> _items;

  List<Resource> get items => List.unmodifiable(_items);

  static final List<Resource> _defaultFixtures = [
    Resource(
      id: 'a',
      title: 'Introducción a Flutter',
      category: ResourceCategory.flutter,
      author: 'Ana',
      durationMinutes: 30,
      level: ResourceLevel.basico,
      description: 'Primeros pasos con widgets.',
      type: ResourceType.video,
    ),
    Resource(
      id: 'b',
      title: 'Layouts básicos',
      category: ResourceCategory.layouts,
      author: 'Beto',
      durationMinutes: 90,
      level: ResourceLevel.intermedio,
      description: 'Column, Row y Expanded.',
      type: ResourceType.lectura,
    ),
    Resource(
      id: 'c',
      title: 'Slivers en profundidad',
      category: ResourceCategory.slivers,
      author: 'Caro',
      durationMinutes: 120,
      level: ResourceLevel.avanzado,
      description: 'CustomScrollView y delegates.',
      type: ResourceType.practica,
    ),
  ];

  @override
  Future<List<Resource>> getAll() async => List.of(_items);

  @override
  Future<List<Resource>> getFavorites() async =>
      _items.where((r) => r.isFavorite).toList();

  @override
  Future<List<Resource>> search(String query) async {
    final q = query.toLowerCase();
    return _items
        .where(
          (r) =>
              r.title.toLowerCase().contains(q) ||
              r.author.toLowerCase().contains(q) ||
              r.description.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<List<Resource>> filterByCategory(ResourceCategory? category) async =>
      category == null
      ? List.of(_items)
      : _items.where((r) => r.category == category).toList();

  @override
  Future<bool> toggleFavorite(String id) async {
    final i = _items.indexWhere((r) => r.id == id);
    if (i == -1) return false;
    final next = !_items[i].isFavorite;
    _items[i] = _items[i].copyWith(isFavorite: next);
    return next;
  }

  @override
  Future<bool> toggleCompleted(String id) async {
    final i = _items.indexWhere((r) => r.id == id);
    if (i == -1) return false;
    final next = !_items[i].isCompleted;
    _items[i] = _items[i].copyWith(isCompleted: next);
    return next;
  }
}
