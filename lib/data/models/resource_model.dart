import '../../core/constants/categories.dart';
import '../../domain/entities/resource.dart';

/// Extensión de la entidad `Resource` con serialización a/desde SQLite.
class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.title,
    required super.category,
    required super.author,
    required super.durationMinutes,
    required super.level,
    required super.description,
    required super.type,
    super.coverColor,
    super.isFavorite,
    super.isCompleted,
  });

  /// Nombre de la tabla.
  static const String table = 'resources';

  /// Construye el modelo desde una fila de SQLite.
  factory ResourceModel.fromMap(Map<String, Object?> map) {
    return ResourceModel(
      id: map['id']! as String,
      title: map['title']! as String,
      category: ResourceCategory.fromValue(map['category']! as String),
      author: map['author']! as String,
      durationMinutes: map['duration_minutes']! as int,
      level: ResourceLevel.fromValue(map['level']! as String),
      description: map['description']! as String,
      type: ResourceType.fromValue(map['type']! as String),
      coverColor: map['cover_color'] as String?,
      isFavorite: (map['is_favorite']! as int) == 1,
      isCompleted: (map['is_completed']! as int) == 1,
    );
  }

  /// Serializa el modelo a una fila de SQLite.
  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'category': category.value,
    'author': author,
    'duration_minutes': durationMinutes,
    'level': level.value,
    'description': description,
    'type': type.value,
    'cover_color': coverColor,
    'is_favorite': isFavorite ? 1 : 0,
    'is_completed': isCompleted ? 1 : 0,
  };
}
