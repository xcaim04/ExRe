import 'package:flutter/widgets.dart';
// Prefijado solo para desambiguar `AppLifecycleState` (Flutter) del enum de
// dominio `LifecycleState`, que en esta app se llama distinto a propósito.
import 'package:flutter/widgets.dart' as ui;

import '../../domain/entities/lifecycle_event.dart';

/// Observa el ciclo de vida de la app reportado por Flutter.
///
/// Notifica cada cambio a [onEvent]. Los eventos se acumulan en memoria en
/// `AppState`; no se persisten.
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver({required this.onEvent});

  final void Function(LifecycleEvent event) onEvent;

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    onEvent(LifecycleEvent(state: _map(state), timestamp: DateTime.now()));
  }

  /// Traduce el enum de Flutter al enum de dominio.
  LifecycleState _map(ui.AppLifecycleState state) => switch (state) {
    ui.AppLifecycleState.resumed => LifecycleState.resumed,
    ui.AppLifecycleState.inactive => LifecycleState.inactive,
    ui.AppLifecycleState.hidden => LifecycleState.hidden,
    ui.AppLifecycleState.paused => LifecycleState.paused,
    ui.AppLifecycleState.detached => LifecycleState.detached,
  };
}
