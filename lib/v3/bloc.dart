class Bloc {
  void call<E>(E event) {
    final handlers = _listeners[event.runtimeType];
    if (handlers == null || handlers.isEmpty) {
      print('No handlers for ${event.runtimeType}');
      return;
    }
    for (final handler in handlers) {
      handler(event);
    }
    print('[$E]');
  }

  void on<E>(void Function(E event) callback) {
    print("[${this.runtimeType}] => [$E]");
    _listeners.putIfAbsent(E, () => []).add(callback);
  }

  late final emit = call;
  final Map<Type, List<Function>> _listeners = {};
}
