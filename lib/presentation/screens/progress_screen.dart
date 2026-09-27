import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/usecases/get_progress_stats.dart';
import '../state/app_state.dart';
import '../widgets/stat_card.dart';

/// Pantalla de Progreso: porcentaje general y breakdown por categoría.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = AppStateScope.of(context);
    final stats = state.progressStats;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        AppSpacing.xl,
      ),
      children: [
        Text(
          'Progreso',
          style: AppTypography.display22.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 20),

        // ------------------------------------------------- Porcentaje general
        _OverallCard(stats: stats),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: '${stats.completed}',
                label: 'Completados',
                icon: Icons.check_circle,
                valueColor: c.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                value: '${stats.pending}',
                label: 'Pendientes',
                icon: Icons.pending_outlined,
                valueColor: c.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: _hours(stats.completedMinutes),
                label: 'Tiempo hecho',
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                value: _hours(stats.totalMinutes),
                label: 'Tiempo total',
                icon: Icons.timelapse,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --------------------------------------------- Breakdown por categoría
        Text(
          'Por categoría',
          style: AppTypography.display16.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        for (final entry in stats.byCategory) ...[
          _CategoryRow(progress: entry),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  /// Minutos a horas legibles, p. ej. `3 h 25 min`.
  static String _hours(int minutes) {
    if (minutes == 0) return '0 min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '$m min';
    return m == 0 ? '$h h' : '$h h $m min';
  }
}

/// Tarjeta con el anillo de progreso general.
class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: stats.total == 0 ? 0 : stats.completed / stats.total,
                    strokeWidth: 6,
                    backgroundColor: c.border,
                    valueColor: AlwaysStoppedAnimation(c.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '${stats.overallPercent}%',
                  style: AppTypography.body12.copyWith(color: c.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso general',
                  style: AppTypography.display16.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stats.completed} de ${stats.total} recursos completados',
                  style: AppTypography.body12.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${stats.timePercent}% del tiempo total',
                  style: AppTypography.body11.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila del breakdown: punto, nombre, barra y conteo `completados/total`.
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.progress});

  final CategoryProgress progress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // `Dot` con el color fuerte de la categoría.
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: progress.category.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  progress.category.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body14.copyWith(color: c.textPrimary),
                ),
              ),
              Text(
                '${progress.completed}/${progress.total}',
                style: AppTypography.body12.copyWith(color: c.textSecondary),
              ),
              const SizedBox(width: 8),
              Text(
                '${progress.percent}%',
                style: AppTypography.body12.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: LinearProgressIndicator(
              value: progress.ratio,
              minHeight: 6,
              backgroundColor: c.border,
              valueColor: AlwaysStoppedAnimation(progress.category.color),
            ),
          ),
        ],
      ),
    );
  }
}
