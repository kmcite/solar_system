import 'package:manager/manager.dart';

class BatteryBloc {
  final batteryRM = RM.inject(
    () => Battery(),
    persist: () => PersistState(
      key: 'battery',
      toJson: (s) => jsonEncode(s.toJson()),
      fromJson: (json) => Battery.fromJson(jsonDecode(json)),
    ),
  );

  Battery get battery => batteryRM.state;
  bool get isPoweringLoads => battery.isPoweringLoads;
  int get currentCapacity => battery.currentCapacity;
  int get maximumCapacity => battery.maximumCapacity;

  void togglePower() {
    batteryRM.state = battery..isPoweringLoads = !battery.isPoweringLoads;
    batteryRM.notify();
  }

  void charge(int amount) {
    batteryRM.state = battery
      ..currentCapacity = (currentCapacity + amount).clamp(0, maximumCapacity);
    batteryRM.notify();
  }

  void discharge(int amount) {
    batteryRM.state = battery
      ..currentCapacity = (currentCapacity - amount).clamp(0, maximumCapacity);
    batteryRM.notify();
  }

  void toggle() {}
}

final batteryBloc = BatteryBloc();

class Battery {
  bool isPoweringLoads = false;
  bool isCharging = false;

  int maximumCapacity = 5000;
  int currentCapacity = 1500;
  Map<String, dynamic> toJson() => {
        "isPoweringLoads": isPoweringLoads,
        // "chargingRate": chargingRate,
        "isCharging": isCharging,
        "maximumCapacity": maximumCapacity,
        "currentCapacity": currentCapacity,
      };

  Battery.fromJson(Map<String, dynamic> json) {
    isPoweringLoads = json['isPoweringLoads'] ?? false;
    isCharging = json['isCharging'] ?? false;
    // chargingRate = json['chargingRate'] ?? 100;
    maximumCapacity = json['maximumCapacity'] ?? 5000;
    currentCapacity = json['currentCapacity'] ?? 1500;
  }
  Battery();
}
