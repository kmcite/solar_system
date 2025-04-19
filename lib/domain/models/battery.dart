import 'dart:async';

import 'package:solar_system/main.dart';

final batteryRepository = Battery();

enum BatteryState {
  charging,
  discharging,
  idle,
}

class Battery {
  static const double maxCapacity = 1.0;
  static const double minCapacity = 0.0;
  static const double baseVoltage = 11.0; // Base voltage in volts
  static const double capacityVoltageFactor = 2.5;
  static const double conversionFactor = 1000.0;
  static const double capacityInAh = 100;

  Battery() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      update,
    );
  }

  BatteryState get state {
    if (netPower > 0) {
      return BatteryState.charging;
    } else if (netPower < 0) {
      return BatteryState.discharging;
    } else {
      return BatteryState.idle;
    }
  }

  Timer? timer;
  double capacity = maxCapacity; // Initial capacity in Ah
  double chargingPower = 0.0; // Positive power in watts
  double dischargingPower = 0.0; // Positive power in watts
  double get netPower => chargingPower - dischargingPower;

  double get remainingCapacity => capacity * capacityInAh;
  double get voltage {
    return baseVoltage + (capacity * capacityVoltageFactor);
  }

  void update(_) {
    double change = (netPower / (voltage + 0.5)) / conversionFactor;

    capacity = (capacity + change).clamp(minCapacity, maxCapacity);
    notifyListeners();
  }

  void setChargingPower(double power) {
    chargingPower = power;
    notifyListeners();
  }

  void setDischargingPower(double power) {
    dischargingPower = power;
    notifyListeners();
  }

  void dispose() {
    timer?.cancel();
  }
}
