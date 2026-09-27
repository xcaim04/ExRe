/// Estado del ciclo de vida de la app, tal como lo reporta Flutter.
enum LifecycleState {
  resumed,
  inactive,
  hidden,
  paused,
  detached;

  String get label => switch (this) {
    LifecycleState.resumed => 'Foreground',
    LifecycleState.inactive => 'Inactivo',
    LifecycleState.hidden => 'Oculto',
    LifecycleState.paused => 'Pausado',
    LifecycleState.detached => 'Desacoplado',
  };
}

/// Un evento de ciclo de vida observado en tiempo real.
///
/// Se guarda solo en memoria (el enunciado pide observación en tiempo real,
/// no persistencia de logs).
class LifecycleEvent {
  const LifecycleEvent({required this.state, required this.timestamp});

  final LifecycleState state;
  final DateTime timestamp;

  String get timeLabel {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifecycleEvent &&
          other.state == state &&
          other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(state, timestamp);
}
