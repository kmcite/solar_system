import 'dart:async';
import 'package:signals_flutter/signals_core.dart';

final batteryRepository = Battery();

class Battery {
  final maximumBatteryCapacity = signal(2.0);

  final status = signal(false);

  final capacity = signal(1.0);

  Timer? timer;
  Battery() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      update,
    );
  }

  void update(_) {
    if (capacity() < maximumBatteryCapacity()) {
      changeCapacityBasedOnStatus();
    }
  }

  void changeCapacityBasedOnStatus() {
    if (status()) {
      capacity.value -= .1;
    } else {
      capacity.value += .1;
    }
  }

  double get current => 0;
  double get voltage => 0;
  double get power => voltage * current;

  void charge(double value) {
    capacity.value += value;
  }

  void discharge(double value) {
    capacity.value -= value;
  }

  void turnOn() {
    status.value = true;
  }

  void turnOff() {
    status.value = false;
  }
}
