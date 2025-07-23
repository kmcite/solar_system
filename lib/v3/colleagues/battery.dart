import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/v3/colleagues/flow.dart';
import 'package:solar_system/v3/bloc.dart';
import 'package:solar_system/v3/colleagues/panels.dart';

final Battery battery = Battery();

class Battery extends Bloc {
  Battery() {
    on<InformBatteryAboutPanels>(
      (event) {
        print(event);
      },
    );
    on<ChargeFlow>(
      (event) {
        if (isCharging()) {
          if (charge() + event.charge >= capacity()) {
            return;
          }
          this.charge.set(this.charge() + event.charge);
        }
      },
    );
    on<BatteryFull>(
      (event) {
        charge.set(capacity());
        isCharging.set(false);
      },
    );
    on<BatteryDischarge>(
      (event) {
        this.charge.set(this.charge() - event.discharge);
      },
    );
    on<StartChargingBattery>(
      (event) {
        this.isCharging.set(true);
      },
    );
    on<StopChargingBattery>(
      (event) {
        this.isCharging.set(false);
      },
    );
  }
  late final isBatteryFull = computed(() => charge() >= capacity());
  final isCharging = signal(false);
  final charge = signal(0.0);
  final capacity = signal(4.0);
  late final progress = computed(() => charge() / capacity());
  late final percentage = computed(() => (progress() * 100).toInt());
  final batteryVoltage = signal(48.0);
}

class BatteryFull {
  const BatteryFull();
}

class BatteryDischarge {
  final double discharge;
  const BatteryDischarge(this.discharge);
}

class StartChargingBattery {}

class StopChargingBattery {}
