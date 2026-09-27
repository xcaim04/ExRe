import '../../../core/constants/categories.dart';
import '../entities/resource.dart';

/// Resumen de progreso de una sola categoría.
class CategoryProgress {
  const CategoryProgress({
    required this.category,
    required this.total,
    required this.completed,
  });

  final ResourceCategory category;
  final int total;
  final int completed;

  double get ratio => total == 0 ? 0 : completed / total;

  int get percent => (ratio * 100).round();
}

/// Estadísticas globales de progreso.
class ProgressStats {
  const ProgressStats({
    required this.total,
    required this.completed,
    required this.favorites,
    required this.totalMinutes,
    required this.completedMinutes,
    required this.byCategory,
  });

  const ProgressStats.empty()
    : total = 0,
      completed = 0,
      favorites = 0,
      totalMinutes = 0,
      completedMinutes = 0,
      byCategory = const <CategoryProgress>[];

  final int total;
  final int completed;
  final int favorites;
  final int totalMinutes;
  final int completedMinutes;
  final List<CategoryProgress> byCategory;

  /// Porcentaje general de recursos completados (0-100).
  int get overallPercent =>
      total == 0 ? 0 : ((completed / total) * 100).round();

  /// Progreso en tiempo, no en cantidad de recursos.
  int get timePercent =>
      totalMinutes == 0 ? 0 : ((completedMinutes / totalMinutes) * 100).round();

  int get pending => total - completed;
}

/// Calcula las estadísticas de progreso a partir de la lista de recursos.
///
/// Caso de uso puro: no toca la base de datos, para que sea trivial de testear.
class GetProgressStats {
  const GetProgressStats();

  ProgressStats call(List<Resource> resources) {
    if (resources.isEmpty) return const ProgressStats.empty();

    var completed = 0;
    var favorites = 0;
    var totalMinutes = 0;
    var completedMinutes = 0;

    for (final r in resources) {
      totalMinutes += r.durationMinutes;
      if (r.isCompleted) {
        completed++;
        completedMinutes += r.durationMinutes;
      }
      if (r.isFavorite) favorites++;
    }

    final byCategory = <CategoryProgress>[];
    for (final category in ResourceCategory.values) {
      final inCategory = resources.where((r) => r.category == category);
      if (inCategory.isEmpty) continue;
      byCategory.add(
        CategoryProgress(
          category: category,
          total: inCategory.length,
          completed: inCategory.where((r) => r.isCompleted).length,
        ),
      );
    }

    return ProgressStats(
      total: resources.length,
      completed: completed,
      favorites: favorites,
      totalMinutes: totalMinutes,
      completedMinutes: completedMinutes,
      byCategory: byCategory,
    );
  }
}
