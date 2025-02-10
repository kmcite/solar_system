import 'package:forui/forui.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/system/battery/battery_page.dart';
import 'package:solar_system/system/inverter/inverter_page.dart';
import 'package:solar_system/system/panel/panel_page.dart';
import 'package:solar_system/system/system_bloc.dart';
import 'package:solar_system/system/utility/utility_page.dart';

class SystemPage extends UI {
  const SystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'System'.text(),
        actions: [
          FHeaderAction(
            onPress: () {
              if (solarSystem.flowSubscription?.isPaused ?? true)
                solarSystem.startFlow();
              solarSystem.stopFlow();
            },
            icon: FIcon(FAssets.icons.zapOff),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          solarSystem.flowSubscription?.isPaused ?? true
              ? Button.icon(
                  onPressed:
                      solarSystem.isFullyLoaded ? null : solarSystem.startFlow,
                  icon: 'FULL ENERGY'.text(),
                )
              : TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: solarSystem.energy.toDouble(),
                    end: solarSystem.energy / solarSystem.maxEnergy,
                  ),
                  duration: 750.milliseconds,
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        FProgress(
                          value: value,
                          style: FProgressStyle(
                            constraints: context.theme.progressStyle.constraints
                                .copyWith(maxHeight: 24),
                            backgroundDecoration: context
                                .theme.progressStyle.backgroundDecoration,
                            progressDecoration:
                                context.theme.progressStyle.progressDecoration,
                          ),
                        ),
                        child!,
                      ],
                    );
                  },
                  child: '${solarSystem.energy} / ${solarSystem.loadedEnergy}'
                      .text()
                      .pad(),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Button.icon(
                    onPressed: () {
                      navigator.to(InverterPage());
                    },
                    icon: FIcon(FAssets.icons.fileInput),
                  ).pad(),
                  "INVERTER".text(style: TextStyle(fontSize: 20)).pad(),
                ],
              ),
              Button(
                onPressed: inverterBloc.toggle,
                child: (inverterBloc.inverter.status
                        ? 'CONNECTED'
                        : 'DISCONNECTED')
                    .text()
                    .pad(),
              ).pad(),
            ],
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Button.icon(
                    onPressed: () => navigator.to(BatteryPage()),
                    icon: FIcon(FAssets.icons.batteryFull),
                  ).pad(),
                  "BATTERY".text(style: TextStyle(fontSize: 20)).pad(),
                ],
              ),
              Button(
                onPressed: batteryBloc.togglePower,
                child: Text(
                  batteryBloc.battery.isPoweringLoads
                      ? 'CONNECTED'
                      : 'DISCONNECTED',
                ),
              ).pad(),
              batteryBloc.currentCapacity.text().pad(),
              FProgress(
                value:
                    batteryBloc.currentCapacity / batteryBloc.maximumCapacity,
              ).pad(),
            ],
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Button.icon(
                    onPressed: () {
                      navigator.to(PanelPage());
                    },
                    icon: FIcon(FAssets.icons.panelBottom),
                  ).pad(),
                  "PANELS".text(style: TextStyle(fontSize: 20)).pad(),
                ],
              ),
              Button(
                onPressed: panelsBloc.toggle,
                child: '${panelsBloc.status ? 'BEING USED' : 'OFF'}'.text(),
              ).pad(),
            ],
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Button.icon(
                    onPressed: () {
                      navigator.to(UtilityPage());
                    },
                    icon: FIcon(FAssets.icons.bolt),
                  ).pad(),
                  "UTILITY".text().pad(),
                ],
              ),
              FCheckbox(
                value: utilityBloc.utility.isPoweringLoads,
                onChange: (_) => utilityBloc.toggle(),
              ),
            ],
          ).pad(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                "LOADS".text().pad(),
                Button(
                  onPressed: () {
                    navigator.to(LoadsPage());
                  },
                  child: Text('LOADS'),
                ).pad(),
              ],
            ).pad(),
          ),
        ],
      ),
    );
  }
}
