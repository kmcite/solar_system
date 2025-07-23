import 'package:faker/faker.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/v3/bloc.dart';
import 'package:solar_system/v3/colleagues/battery.dart';
import 'package:solar_system/v3/colleagues/flow.dart';

class Panel {
  String id = faker.guid.guid();
  double power = faker.randomGenerator.decimal(scale: 75, min: 550);
  late final current = computed(() => power / volatage);
  double volatage = faker.randomGenerator.decimal(scale: 6, min: 45);
}

final panels = Panels();

class Panels extends Bloc {
  Panels() {
    on<InformBatteryAboutPanels>((event) {
      // forward this to battery
      battery(event);
    });
    on<PutPanel>((event) {
      panels[event.panel.id] = event.panel;
      emit(InformBatteryAboutPanels());
    });
    on<RemovePanel>((event) {
      panels.remove(event.panel.id);
      emit(InformBatteryAboutPanels());
    });
    on<ChargeFlow>((event) {
      percentage.set(event.charge);
      emit(InformBatteryAboutPanels());
    });
  }
  late final effectivePower = computed(
    () => (percentage() * totalPower()).toInt(),
  );
  final percentage = signal(0.0);
  final panels = mapSignal<String, Panel>({});
  late final totalPower = computed(
    () => panels.values.fold(0.0, (p, c) => p + c.power),
  );

  Panel? get(String id) => panels[id];
}

class PutPanel extends InformBatteryAboutPanels {
  final Panel panel;
  const PutPanel(this.panel);
}

class RemovePanel {
  final Panel panel;
  const RemovePanel(this.panel);
}

/// this will inform the battery about the panels
class InformBatteryAboutPanels {
  const InformBatteryAboutPanels();
}
