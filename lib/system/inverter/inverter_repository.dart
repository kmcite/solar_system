// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:manager/hydrated.dart' show Hydrated;
import 'package:manager/manager.dart';

final inverterRepository = InverterRepository();

class InverterRepository extends Repository<Inverter> {
  final _inverter = Hydrated<Inverter>(
    Inverter.fromMap,
    initialState: Inverter(),
  );

  Inverter get inverter {
    return _inverter();
  }

  set inverter(Inverter value) {
    _inverter.put(value);
    notify(value);
  }

  bool get status => inverter.status;
  bool get upgradable => inverter.upgradable;
  int get usage => inverter.usage;
  int get capacity => inverter.capacity;

  Timer? upgradeCooldown;
  void toggle([_]) {
    inverter = inverter.copyWith(status: !inverter.status);
  }

  void upgradeCapacity(int amount) {
    inverter = inverter.copyWith(
      capacity: inverter.capacity + amount,
      upgradable: false,
    );

    upgradeCooldown = Timer(10.seconds, () {
      inverter = inverter.copyWith(upgradable: true);
    });
  }
}

class Inverter extends Equatable {
  final bool status;
  final bool upgradable;
  final int usage;
  final int capacity;

  Inverter({
    this.status = false,
    this.upgradable = true,
    this.usage = 0,
    this.capacity = 500,
  });

  Inverter copyWith({
    bool? status,
    bool? upgradable,
    int? usage,
    int? capacity,
  }) {
    return Inverter(
      status: status ?? this.status,
      upgradable: upgradable ?? this.upgradable,
      usage: usage ?? this.usage,
      capacity: capacity ?? this.capacity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'upgradable': upgradable,
      'usage': usage,
      'capacity': capacity,
    };
  }

  factory Inverter.fromMap(Map<String, dynamic> map) {
    return Inverter(
      status: (map['status'] ?? false) as bool,
      upgradable: (map['upgradable'] ?? false) as bool,
      usage: (map['usage'] ?? 0) as int,
      capacity: (map['capacity'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Inverter.fromJson(String source) =>
      Inverter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, upgradable, usage, capacity];
}
