// ignore_for_file: override_on_non_overriding_member, unused_element

import 'dart:async';
import 'dart:math';

import 'package:solar_system/main.dart';

class Utility {
  var time = 30;
  var rate = 0.0001;
  var status = false;
  var voltage = 220.0;
  var energyConsumed = 0.0;
  var loads = 0.0;

  Map<String, dynamic> toJson() => {
    'time': time,
    'rate': rate,
    'status': status,
    'voltage': voltage,
    'energyConsumed': energyConsumed,
    'loads': loads,
  };
  Utility();
  Utility.fromJson(Map<String, dynamic> json) {
    time = json['time'] ?? 0;
    rate = json['rate'] ?? 0;
    status = json['status'] ?? false;
    voltage = json['voltage'] ?? 0;
    energyConsumed = json['energyConsumed'] ?? 0;
    loads = json['loads'] ?? 0;
  }
}

class UtilityRepository extends Repository<Utility> {
  UtilityRepository() : super(Utility());
  @override
  // Future<void> init() {
  //   _timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     _updateUtility,
  //   );
  //   return super.init();
  // }
  /// INTERNAL LOGIC OF UTILITY
  // ignore: unused_field
  Timer? _timer;

  void _updateUtility(Timer _) {
    _updateTime();
    _updateVoltageBasedOnStatus();
    _updateEnergyConsumption();
  }

  void _updateTime() {
    if (value.status) {
      if (value.time <= 0)
        turnOff();
      else
        emit(value..time -= 1);
    }
  }

  void _updateVoltageBasedOnStatus() {
    if (value.status) {
      emit(value..voltage = Random().nextInt(40) + 190);
    } else {
      emit(value..voltage = 0);
    }
  }

  /// PUBLIC API
  void _updateEnergyConsumption() {
    emit(value..energyConsumed += value.loads);
  }

  void setStatus(bool status) {
    emit(value..status = status);
  }

  void turnOn() {
    setStatus(true);
  }

  void turnOff() {
    setStatus(false);
  }

  void toggle() {
    setStatus(!value.status);
  }

  void buy(int time) {
    emit(value..time += time);
  }

  /// PERSIST API
  @override
  Utility fromJson(Map<String, dynamic> json) => Utility.fromJson(json);

  @override
  String get key => 'utility';

  @override
  Map<String, dynamic> toJson(Utility value) => value.toJson();
}
