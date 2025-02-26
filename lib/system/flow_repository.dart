import 'dart:math';
import 'package:solar_system/main.dart';

final flowRepository = FlowRepository();

class FlowRepository {
  StreamSubscription<double>? _subscription;
  FlowRepository() {
    _startStream();
  }

  void pause() {
    _subscription?.pause();
    isFlowPausedRM.state = true;
  }

  void resume() {
    _subscription?.resume();
    isFlowPausedRM.state = false;
  }

  void _startStream() {
    final random = Random();
    isFlowPausedRM.state = false;
    _subscription = Stream.periodic(
      1.seconds,
      (_) => random.nextDouble(),
    ).listen(
      (value) => flowRM.state = value,
    );
  }

  void close() {
    _subscription?.cancel();
    isFlowPausedRM.state = true;
  }

  final isFlowPausedRM = true.inj();
  final flowRM = RM.inject<double>(() => 0);
  final temporaryStorageRM = RM.inject(() => TemporaryStorage());

  double get flow => flowRM.state;

  bool get isFlowPaused => isFlowPausedRM.state;
}

class TemporaryStorage {
  int capacity = 1500;
  int usage = 0;
  int get remaining => capacity - usage;
  int storage = 0;
  void updateStorage(int amount) {
    final _storage = storage + amount;
    if (_storage >= capacity) {
      storage = capacity;
    } else {
      storage = _storage;
    }
  }

  void updateCapacity(int amount) {
    capacity = capacity + amount;
  }
}
