import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/lifecycle/app_lifecycle_observer.dart';
import 'presentation/state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección de dependencias manual: un solo grafo, pasado explícitamente.
  final injection = Injection.build();
  final state = AppState(injection);

  // Observador de ciclo de vida, registrado en el binding.
  final lifecycleObserver = AppLifecycleObserver(
    onEvent: state.onLifecycleEvent,
  );
  WidgetsBinding.instance.addObserver(lifecycleObserver);

  // Carga inicial: siembra SQLite si hace falta y lee los recursos.
  state.load();

  runApp(ExreApp(state: state));
}
