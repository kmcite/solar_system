import 'package:manager/manager.dart';

final inverterRepository = InverterRepository();

class InverterRepository {
  final inverterRM = RM.inject(
    () => Inverter(),
    persist: () => PersistState(
      key: 'inverter',
      toJson: (s) => jsonEncode(s.toJson()),
      fromJson: (json) => Inverter.fromJson(jsonDecode(json)),
    ),
  );

  set inverter(Inverter value) => inverterRM
    ..state = value
    ..notify();

  Inverter get inverter => inverterRM.state;
  bool get status => inverter.status;
  bool get upgradable => inverter.upgradable;
  int get usage => inverter.usage;
  int get capacity => inverter.capacity;

  Timer? upgradeCooldown;

  void toggle([_]) => inverter = inverter..status = !inverter.status;
  void upgradeCapacity(int amount) {
    inverter = inverter
      ..capacity = inverter.capacity + amount
      ..upgradable = false;

    upgradeCooldown = Timer(
      10.seconds,
      () {
        inverter = inverter..upgradable = true;
      },
    );
  }
}

class Inverter {
  bool status = false;
  bool upgradable = true;
  int usage = 0;
  int capacity = 500;

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "upgradable": upgradable,
      "usage": usage,
      "capacity": capacity,
    };
  }

  Inverter.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    upgradable = json['upgradable'] ?? true;
    usage = json['usage'] ?? 0;
    capacity = json['capacity'] ?? 500;
  }
  Inverter();
}
