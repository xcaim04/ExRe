import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Barra de estado simulada: hora a la izquierda, iconos a la derecha.
///
/// Alto 62, padding horizontal 20, fondo `colorBg`, `space-between`.
class AppStatusBar extends StatelessWidget {
  const AppStatusBar({super.key});

  static const double height = 62;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      color: c.bg,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Clock(),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: c.textPrimary),
              const SizedBox(width: 6),
              Icon(Icons.wifi, size: 16, color: c.textPrimary),
              const SizedBox(width: 6),
              Icon(Icons.battery_full, size: 16, color: c.textPrimary),
            ],
          ),
        ],
      ),
    );
  }
}

/// Muestra la hora actual y se refresca en el cambio de minuto.
class _Clock extends StatefulWidget {
  const _Clock();

  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _label {
    final h = _now.hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _label,
      style: AppTypography.statusBarClock.copyWith(
        color: context.colors.textPrimary,
      ),
    );
  }
}
