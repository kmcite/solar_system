import 'package:signals_flutter/signals_core.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/v3/colleagues/battery.dart';
import 'package:solar_system/v3/colleagues/flow.dart';
import 'package:solar_system/v3/colleagues/inverter.dart';
import 'package:solar_system/v3/colleagues/panels.dart';
import 'package:solar_system/v3/colleagues/utility.dart';

final effectivePower = computed(
  () {
    if (inverter.isRunning())
      return panels.totalPower() * flow.percentage();
    else
      return 0.0;
  },
);

IconData icon(int percentage, {bool isCharging = false}) {
  if (isCharging) return Icons.battery_charging_full;

  if (percentage > 80) {
    return Icons.battery_full;
  } else if (percentage > 60) {
    return Icons.battery_6_bar;
  } else if (percentage > 40) {
    return Icons.battery_4_bar;
  } else if (percentage > 20) {
    return Icons.battery_2_bar;
  } else {
    return Icons.battery_0_bar;
  }
}

class HomePage extends UI {
  @override
  void initState() {
    super.initState();
    flow(StartFlow());
  }

  @override
  void dispose() {
    flow(StopFlow());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Solar System'.text(),
        suffixes: [
          FHeaderAction(
            icon: Icon(inverter.dark() ? FIcons.sun : FIcons.moon),
            onPress: () => inverter(ToggleDark()),
          ),
          FHeaderAction(
            icon: Icon(
              flow.flowing() ? FIcons.thermometerSun : FIcons.watch,
            ),
            onPress: () => flow(ToggleFlow()),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          FProgress(
            value: flow.percentage(),
          ),
          FTile(
            title: Text(
              "${effectivePower().toStringAsFixed(0)} watts",
              style: TextStyle(fontSize: 28),
            ),
            subtitle: Row(
              children: [
                FButton.icon(
                  onPress: () {
                    inverter(ToggleInverter());
                  },
                  child: Icon(
                    inverter.isRunning() ? FIcons.power : FIcons.powerOff,
                  ),
                ),
              ],
            ),
          ),
          FTile(
            title: Text(
              'Battery => ${(battery.progress() * 100).toStringAsFixed(0)}%',
            ),
            subtitle: FButton.icon(
              onPress: () {},
              child: Icon(
                icon(
                  battery.percentage(),
                  isCharging: battery.isCharging(),
                ),
              ),
            ),
            suffix: Column(
              spacing: 8,
              children: [
                FButton.icon(
                  onPress: battery.isCharging()
                      ? null
                      : () => battery(StartChargingBattery()),
                  child: Icon(Icons.start),
                ),
                FButton.icon(
                  onPress: battery.isCharging()
                      ? () => battery(StopChargingBattery())
                      : null,
                  child: Icon(Icons.stop),
                ),
              ],
            ),
          ),
          FProgress(
            value: battery.progress(),
          ),
          FTile(
            title: 'Panels'.text(),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    FButton.icon(
                      onPress: () => panels(PutPanel(Panel())),
                      child: Icon(FIcons.plus),
                    ),
                    Text(
                      "Production: ${panels.effectivePower()} watts\n"
                      "Max Power: ${panels.totalPower().toStringAsFixed(0)} watts\n"
                      "Effective Light: ${(panels.percentage() * 100).toStringAsFixed(0)}%",
                    )
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final panel in panels.panels.values)
                      FButton.icon(
                        style: FButtonStyle.destructive(),
                        onPress: () => panels(RemovePanel(panel)),
                        child: Icon(FIcons.panelRightDashed),
                      ),
                  ],
                ),
              ],
            ),
          ),
          FTile(
            title: 'Utility'.text(),
            subtitle: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FButton.icon(
                  onPress: () {},
                  child: Icon(FIcons.utilityPole),
                ),
              ],
            ),
            details: Column(
              spacing: 8,
              children: [
                FButton.icon(
                  onPress: () {},
                  child: Icon(FIcons.aArrowUp),
                ),
                FButton.icon(
                  onPress: () {},
                  child: Icon(FIcons.aArrowUp),
                ),
              ],
            ),
            onPress: () => utility(StartUtilityUsage()),
          ),
        ],
      ),
    );
  }
}
