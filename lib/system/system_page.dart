import 'package:solar_system/navigator.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/system/inverter/inverter_page.dart';
import 'package:solar_system/system/panel/panel_page.dart';
import 'dark_repository.dart';
import 'flow_repository.dart';
import 'utility/utility_page.dart';

final systemBloc = SystemBloc();

class SystemBloc {
  double flow = 0;
  SystemBloc() {
    flowRepository.register((_flow) {
      flow = _flow;
      print('onFlow:SystemBloc');
    });
  }

  bool get dark => darkRepository.dark;
  late final toggleDark = darkRepository.toggleDark;
  bool get inverterStatus => inverterRepository.status;
  late final toggleInverterStatus = inverterRepository.toggle;

  bool get flowing => flowRepository.flowing;
  void toggleFlow() {
    if (flowing) {
      flowRepository.pause();
    } else {
      flowRepository.resume();
    }
  }

  int get currentFlowProduction =>
      (flowRepository.flow / inverterRepository.capacity).toInt();

  int get tempStorageCapacity =>
      flowRepository.temporaryStorage.capacity;
  int get tempStorage => flowRepository.temporaryStorage.storage;
  double get storage => tempStorage / tempStorageCapacity;
}

class SystemPage extends UI {
  const SystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: ''.text(),
        actions: [
          FButton.icon(
            onPress: systemBloc.toggleFlow,
            child: FIcon(
              systemBloc.flowing
                  ? FAssets.icons.zap
                  : FAssets.icons.zapOff,
            ),
          ),
          FButton.icon(
            onPress: systemBloc.toggleDark,
            child: FIcon(
              systemBloc.dark
                  ? FAssets.icons.moon
                  : FAssets.icons.sun,
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              FProgress(
                value: systemBloc.flow,
                style: FProgressStyle(
                  constraints: context.theme.progressStyle.constraints
                      .copyWith(maxHeight: 40),
                  backgroundDecoration:
                      context
                          .theme
                          .progressStyle
                          .backgroundDecoration,
                  progressDecoration:
                      context.theme.progressStyle.progressDecoration,
                ),
              ).pad(),
              systemBloc.currentFlowProduction.text(),
            ],
          ),
          FProgress(
            value: systemBloc.storage,
            style: FProgressStyle(
              constraints: context.theme.progressStyle.constraints
                  .copyWith(maxHeight: 40),
              backgroundDecoration:
                  context.theme.progressStyle.backgroundDecoration,
              progressDecoration:
                  context.theme.progressStyle.progressDecoration,
            ),
          ).pad(),
          // Inverter
          Row(
            children: [
              FButton.icon(
                onPress: () => navigator.to(InverterPage()),
                child: FIcon(FAssets.icons.fileInput),
              ).pad(),
              "INVERTER".text(style: TextStyle(fontSize: 20)).pad(),
              Spacer(),
              FSwitch(
                value: systemBloc.inverterStatus,
                onChange: systemBloc.toggleInverterStatus,
              ),
            ],
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  FButton.icon(
                    onPress: () {
                      // _system.to(BatteryPage());
                    },
                    child: FIcon(FAssets.icons.batteryFull),
                  ).pad(),
                  "BATTERY"
                      .text(style: TextStyle(fontSize: 20))
                      .pad(),
                  Spacer(),
                  FSwitch(
                    value: batteryRepository.isPoweringLoads(),
                    onChange: batteryRepository.isPoweringLoads,
                  ),
                ],
              ),
            ],
          ).pad(),
          Row(
            children: [
              FButton.icon(
                onPress: () {
                  navigator.to(PanelPage());
                },
                child: FIcon(FAssets.icons.panelBottom),
              ).pad(),
              "PANELS".text(style: TextStyle(fontSize: 20)).pad(),
              Spacer(),
              FSwitch(
                value: panelsBloc.status,
                onChange: (_) => panelsBloc.toggle(),
              ),
            ],
          ).pad(),
          Row(
            children: [
              FButton.icon(
                onPress: () {
                  navigator.to(UtilityPage());
                },
                child: FIcon(FAssets.icons.bolt),
              ).pad(),
              "UTILITY".text().pad(),
              Spacer(),
              FSwitch(
                value: utilityBloc.utility.isPoweringLoads,
                onChange: (_) => utilityBloc.toggle(),
              ),
            ],
          ).pad(),
          Row(
            children: [
              FButton.icon(
                onPress: () {
                  navigator.to(LoadsPage());
                },
                child: FIcon(FAssets.icons.loader),
              ).pad(),
              "LOADS".text().pad(),
              Spacer(),
              FSwitch(
                value: loadsBloc.loads.status,
                onChange: (_) => loadsBloc.toggle(),
              ),
            ],
          ).pad(),
          flowRepository.temporaryStorage.text(),
        ],
      ),
    );
  }
}
