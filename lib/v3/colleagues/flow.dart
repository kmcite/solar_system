import 'dart:async';

import 'package:faker/faker.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/v3/bloc.dart';
import 'package:solar_system/v3/colleagues/battery.dart';
import 'package:solar_system/v3/colleagues/panels.dart';

class StartFlow {}

class StopFlow {}

class ToggleFlow {}

class ChargeFlow {
  final double charge;
  const ChargeFlow(this.charge);
}

final flow = Flow();

class Flow extends Bloc {
  Flow() {
    on<StartFlow>(
      (event) {
        flowTimer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            final val = faker.randomGenerator.decimal(
              scale: .4,
              min: .6,
            );
            emit(ChargeFlow(val));
          },
        );
        flowing.set(true);
      },
    );
    on<StopFlow>(
      (event) {
        flowTimer?.cancel();
        flowTimer = null;
        flowing.set(false);
        percentage.set(0);
      },
    );
    on<ToggleFlow>((event) {
      if (flowing()) {
        emit(StopFlow());
      } else {
        emit(StartFlow());
      }
    });
    on<ChargeFlow>((event) {
      percentage.set(event.charge);
      panels(event);
      battery(event);
    });
  }
  Timer? flowTimer;
  final percentage = signal(0.0);
  final flowing = signal(false);
}
