import 'dart:async';

import 'package:faker/faker.dart';
import 'package:solar_system/main.dart';

enum Flowing { running, stopped, idle }

class Flow {
  double solarFlow = 0;
  Flowing flowing = Flowing.idle;
}

class FlowRepository extends Repository<Flow> {
  FlowRepository() : super(Flow());

  Timer? timer;
  @override
  Future<void> init() {
    return super.init();
  }

  void resumeFlow() {
    emit(value..flowing = Flowing.running);
    timer = Timer.periodic(
      Duration(seconds: 1),
      (_) {
        final _value = faker.randomGenerator.decimal(scale: .4, min: .6);
        emit(
          value..solarFlow = _value,
        );
      },
    );
  }

  void toggleFlow() {
    // emit(
    //   value
    //     ..flowing = switch (value.flowing) {
    //       Flowing.idle => Flowing.running,
    //       Flowing.running => Flowing.stopped,
    //       Flowing.stopped => Flowing.idle,
    //     }
    //     ..solarFlow = switch (value.flowing) {
    //       Flowing.idle => 0,
    //       Flowing.running => value.solarFlow,
    //       Flowing.stopped => value.solarFlow,
    //     },
    // );
    // timer?.cancel();
    // timer = null;
    // if (value.flowing == Flowing.running) resumeFlow();
  }

  void pauseFlow() {
    timer?.cancel();
    timer = null;
    emit(
      value
        ..flowing = Flowing.stopped
        ..solarFlow = value.solarFlow,
    );
  }

  void stopFlow() {
    timer?.cancel();
    timer = null;
    emit(
      value
        ..flowing = Flowing.idle
        ..solarFlow = 0,
    );
  }
}
