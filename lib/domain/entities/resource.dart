import '../../../core/constants/categories.dart';

/// Tipo de recurso de estudio.
enum ResourceType {
  video('video'),
  lectura('lectura'),
  practica('práctica'),
  documento('documento');

  const ResourceType(this.value);

  final String value;

  String get label => switch (this) {
    ResourceType.video => 'Video',
    ResourceType.lectura => 'Lectura',
    ResourceType.practica => 'Práctica',
    ResourceType.documento => 'Documento',
  };

  static ResourceType fromValue(String value) => values.firstWhere(
    (t) => t.value == value,
    orElse: () => ResourceType.lectura,
  );
}

/// Nivel de dificultad.
enum ResourceLevel {
  basico('basico'),
  intermedio('intermedio'),
  avanzado('avanzado');

  const ResourceLevel(this.value);

  final String value;

  String get label => switch (this) {
    ResourceLevel.basico => 'Básico',
    ResourceLevel.intermedio => 'Intermedio',
    ResourceLevel.avanzado => 'Avanzado',
  };

  static ResourceLevel fromValue(String value) => values.firstWhere(
    (l) => l.value == value,
    orElse: () => ResourceLevel.basico,
  );
}

/// Entidad de dominio: un recurso de estudio.
class Resource {
  const Resource({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.durationMinutes,
    required this.level,
    required this.description,
    required this.type,
    this.coverColor,
    this.isFavorite = false,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final ResourceCategory category;
  final String author;
  final int durationMinutes;
  final ResourceLevel level;
  final String description;
  final ResourceType type;

  /// Color de portada. Si es `null` se usa el color de la categoría.
  final String? coverColor;

  final bool isFavorite;
  final bool isCompleted;

  Resource copyWith({
    String? id,
    String? title,
    ResourceCategory? category,
    String? author,
    int? durationMinutes,
    ResourceLevel? level,
    String? description,
    ResourceType? type,
    String? coverColor,
    bool? isFavorite,
    bool? isCompleted,
  }) {
    return Resource(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      author: author ?? this.author,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      level: level ?? this.level,
      description: description ?? this.description,
      type: type ?? this.type,
      coverColor: coverColor ?? this.coverColor,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Duración formateada, p. ej. `45 min` o `1 h 20 min`.
  String get durationLabel {
    if (durationMinutes < 60) return '$durationMinutes min';
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return m == 0 ? '$h h' : '$h h $m min';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource &&
          other.id == id &&
          other.title == title &&
          other.category == category &&
          other.author == author &&
          other.durationMinutes == durationMinutes &&
          other.level == level &&
          other.description == description &&
          other.type == type &&
          other.coverColor == coverColor &&
          other.isFavorite == isFavorite &&
          other.isCompleted == isCompleted;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    author,
    durationMinutes,
    level,
    description,
    type,
    coverColor,
    isFavorite,
    isCompleted,
  );
}
