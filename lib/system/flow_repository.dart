import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:solar_system/main.dart';

final flowRepository = FlowRepository();

class FlowRepository {
  // OBSERVERS
  final List<void Function(double)> _list = [];
  // MECHANISM OF OBSERVATION
  void notify(double value) =>
      _list.forEach((callback) => callback(value));
  // OBSERVER REGISTERATION
  void register(void Function(double) callback) =>
      _list.add(callback);

  /// LOGIC
  StreamSubscription? _streamSubscription;
  final flowRM = RM.inject(() => 0.0);
  double get flow => flowRM.state;
  final flowingRM = RM.inject(() => true);
  bool get flowing => flowingRM.state;
  final temporaryStorageRM = RM.inject(() => TemporaryStorage());

  TemporaryStorage get temporaryStorage => temporaryStorageRM.state;
  set temporaryStorage(TemporaryStorage value) {
    temporaryStorageRM.state = value;
  }

  FlowRepository() {
    _streamSubscription = Stream.periodic(
      1.seconds,
      (_) => Random().nextDouble(),
    ).listen((flow) {
      flowRM.state = flow;
      temporaryStorage = temporaryStorage.copyWith(
        storage:
            temporaryStorage.storage +
            (flow * temporaryStorage.capacity / 100).toInt(),
      );
      notify(flow);
    });
  }
  void pause() {
    _streamSubscription?.pause();
    flowingRM.state = false;
  }

  void resume() {
    _streamSubscription?.resume();
    flowingRM.state = true;
  }

  void close() {
    _streamSubscription?.cancel();
  }

  void useStorage(int effectiveStorageUse) {
    temporaryStorage = temporaryStorage.copyWith(
      storage: temporaryStorage.storage - effectiveStorageUse,
      usage: temporaryStorage.usage + effectiveStorageUse,
    );
  }
}

class TemporaryStorage extends Equatable {
  final int capacity;
  final int usage;
  final int storage;
  const TemporaryStorage({
    this.capacity = 1500,
    this.usage = 0,
    this.storage = 0,
  });

  int get remaining => capacity - usage;

  TemporaryStorage updateStorage(int amount) {
    final newStorage = (storage + amount).clamp(0, capacity);
    return copyWith(storage: newStorage);
  }

  TemporaryStorage updateCapacity(int amount) {
    final newCapacity = capacity + amount;
    return copyWith(
      capacity: newCapacity,
      storage: storage.clamp(0, newCapacity),
    );
  }

  TemporaryStorage copyWith({
    int? capacity,
    int? usage,
    int? storage,
  }) {
    return TemporaryStorage(
      capacity: capacity ?? this.capacity,
      usage: usage ?? this.usage,
      storage: storage ?? this.storage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capacity': capacity,
      'usage': usage,
      'storage': storage,
    };
  }

  factory TemporaryStorage.fromMap(Map<String, dynamic> map) {
    return TemporaryStorage(
      capacity: map['capacity'] as int? ?? 0,
      usage: map['usage'] as int? ?? 0,
      storage: map['storage'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemporaryStorage.fromJson(String source) =>
      TemporaryStorage.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [capacity, usage, storage];
}
