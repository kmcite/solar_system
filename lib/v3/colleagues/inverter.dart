import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/v3/bloc.dart';

class InverterStarted {}

class ToggleInverter {}

class ToggleDark {}

final inverter = Inverter();

class Inverter extends Bloc {
  Inverter() {
    on<InverterStarted>(
      (event) {},
    );
    on<ToggleInverter>(
      (event) {
        if (isRunning()) {
          isRunning.set(false);
        } else {
          isRunning.set(true);
        }
      },
    );
    on<ToggleDark>((event) => dark.set(!dark()));
  }

  /// hold state
  final FlutterSignal<bool> dark = signal(true);
  final maxCurrentCapacityForBatteryCharging = signal(120.0);
  final isRunning = signal(false);
}
