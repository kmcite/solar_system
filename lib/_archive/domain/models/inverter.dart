import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

final inverter = Inverter();

class Inverter {
  final status = signal(InverterStatus.notAvailable);
  final operation = signal(InverterOperation.manual);

  void buy() {
    if (isInverterPresent()) return;
    status.value = InverterStatus.off;
    operation.value = InverterOperation.auto;
  }

  bool isInverterPresent() => status.value != InverterStatus.notAvailable;
  bool get isOff => status.value == InverterStatus.off;
  bool get isOn => status.value != InverterStatus.off;

  void sell() {
    status.value = InverterStatus.notAvailable;
    operation.value = InverterOperation.manual;
  }
}

enum InverterStatus {
  battery,
  solar,
  utility,
  off,
  notAvailable;

  IconData get icon {
    return switch (this) {
      InverterStatus.battery => Icons.battery_full,
      InverterStatus.solar => Icons.wb_sunny,
      InverterStatus.utility => Icons.electric_bolt,
      InverterStatus.off => Icons.power_off,
      InverterStatus.notAvailable => Icons.block,
    };
  }
}

enum InverterOperation {
  auto,
  manual;
}
