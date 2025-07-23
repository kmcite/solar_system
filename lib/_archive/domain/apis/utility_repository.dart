import 'dart:async';
import 'dart:math';

import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/main.dart';

final utilityRepository = UtilityRepository();

class UtilityRepository extends ChangeNotifier {
  final time = signal(30);
  final rate = signal(0.0001);
  final status = signal(false);
  final voltage = signal(220.0);
  final energyConsumed = signal(0.0);
  final loads = signal(0.0);

  Timer? timer;
  UtilityRepository() {
    timer = Timer.periodic(const Duration(seconds: 1), update);
  }

  void toggle() {
    status.value = !status.value;
  }

  void update(Timer _) {
    updateTime();
    updateVoltageBasedOnStatus();
    updateEnergyConsumption();
  }

  updateTime() {
    if (status()) {
      if (time() <= 0)
        turnOff();
      else
        time.value -= 1;
    }
  }

  void updateVoltageBasedOnStatus() {
    if (status()) {
      voltage.value = Random().nextInt(40) + 190;
    } else {
      voltage.value = 0;
    }
  }

  void updateEnergyConsumption() {
    energyConsumed.value += loads();
  }

  void turnOn() {
    status.value = true;
  }

  void turnOff() {
    status.value = false;
  }

  void buy(int time) {
    this.time.value += time;
  }
}
