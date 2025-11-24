import 'dart:async';

abstract class Repository<T> {
  final controller = StreamController<T>.broadcast();

  Stream<T> watch() => controller.stream;

  void notify(T data) {
    controller.add(data);
  }
}
