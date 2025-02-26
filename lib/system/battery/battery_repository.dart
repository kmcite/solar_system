import 'package:manager/manager.dart';

final batteryRepository = BatteryRepository();

class BatteryRepository {
  final batteryRM = RM.inject(
    () => Battery(),
    persist: () => PersistState(
      key: 'battery',
      toJson: (s) => jsonEncode(s.toJson()),
      fromJson: (json) => Battery.fromJson(jsonDecode(json)),
    ),
  );
  Battery battery([Battery? value]) {
    if (value != null)
      batteryRM
        ..state = value
        ..notify();
    return batteryRM.state;
  }

  bool isPoweringLoads([bool? value]) {
    if (value != null) battery(battery()..isPoweringLoads = value);
    return battery().isPoweringLoads;
  }

  int currentCapacity([int? value]) {
    if (value != null) battery(battery()..currentCapacity = value);
    return battery().currentCapacity;
  }

  int maximumCapacity([int? value]) {
    if (value != null) battery(battery()..maximumCapacity = value);
    return battery().maximumCapacity;
  }
}

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
