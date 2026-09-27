import 'package:exre/core/constants/categories.dart';
import 'package:exre/domain/usecases/get_progress_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_resource_repository.dart';

void main() {
  const getProgressStats = GetProgressStats();

  test('lista vacía produce estadísticas vacías', () {
    final stats = getProgressStats(const []);

    expect(stats.total, 0);
    expect(stats.completed, 0);
    expect(stats.overallPercent, 0);
    expect(stats.byCategory, isEmpty);
  });

  test('calcula el porcentaje general de completados', () {
    final r = FakeResourceRepository().items;
    // 'a' y 'b' completados sobre 3 -> 67%
    final stats = getProgressStats([
      r[0].copyWith(isCompleted: true),
      r[1].copyWith(isCompleted: true),
      r[2],
    ]);

    expect(stats.total, 3);
    expect(stats.completed, 2);
    expect(stats.pending, 1);
    expect(stats.overallPercent, 67);
  });

  test('el progreso en tiempo usa las duraciones', () {
    final r = FakeResourceRepository().items;
    // Solo 'b' (90 min) de 30+90+120=240 -> 38%
    final stats = getProgressStats([
      r[0],
      r[1].copyWith(isCompleted: true),
      r[2],
    ]);

    expect(stats.totalMinutes, 240);
    expect(stats.completedMinutes, 90);
    expect(stats.timePercent, 38);
  });

  test('el breakdown solo incluye categorías con recursos', () {
    final stats = getProgressStats(FakeResourceRepository().items);

    expect(stats.byCategory, hasLength(3));
    expect(
      stats.byCategory.map((e) => e.category),
      containsAll(<ResourceCategory>[
        ResourceCategory.flutter,
        ResourceCategory.layouts,
        ResourceCategory.slivers,
      ]),
    );
    expect(
      stats.byCategory.any((e) => e.category == ResourceCategory.navegacion),
      isFalse,
    );
  });

  test('cuenta los favoritos', () async {
    final repository = FakeResourceRepository();
    await repository.toggleFavorite('a');

    final stats = getProgressStats(repository.items);

    expect(stats.favorites, 1);
  });
}
