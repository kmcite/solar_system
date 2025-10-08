import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/domain/loads_repository.dart';
import 'package:solar_system/domain/settings_repository.dart';
import 'package:solar_system/domain/utility_repository.dart';
import 'package:solar_system/features/dashboard/utility/utility_toggle.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class UtilityState {
  bool status = false;
  int time = 0;
  double voltage = 0;
  double loads = 0;
  double get current => loads / voltage;

  final bool isUtilitySelectedForPower;
  final double energyUsedFromUtility;
  final double currentDebt;
  final bool isUtilityMode;

  UtilityState({
    required this.isUtilityMode,
    required this.isUtilitySelectedForPower,
    required this.energyUsedFromUtility,
    required this.currentDebt,
  });
}

class UtilityBloc extends Cubit<UtilityState> {
  late InverterRepository inverterRepository = find();
  late UtilityRepository utilityRepository = find();
  late SettingsRepository settingsRepository = find();
  late LoadsRepository loadsRepository = find();

  UtilityBloc()
    : super(
        UtilityState(
          isUtilityMode: false,
          isUtilitySelectedForPower: false,
          energyUsedFromUtility: 0,
          currentDebt: 0,
        ),
      );
  @override
  Future<void> initState() {
    utilityRepository.stream.listen(
      (utility) {
        emit(
          state
            ..status = utility.status
            ..time = utility.time
            ..voltage = utility.voltage,
        );
      },
    );
    loadsRepository.stream.listen(
      (loads) {
        emit(
          state
            ..loads = loads.fold(
              0,
              (a, n) => a + (n.isRunning ? n.power : 0),
            ),
        );
      },
    );
    return super.initState();
  }

  void onDebtsCleared() {
    // money.value -= currentDebt;
    // utilityRepository.energyConsumed.value = 0;
  }

  void onTimeBought() {
    final timeToBuy = 50;
    utilityRepository.buy(timeToBuy);
    settingsRepository.setMoney(settingsRepository().money - 50);
  }
}

class UtilityTile extends Feature<UtilityBloc> {
  @override
  UtilityBloc create() => UtilityBloc();

  @override
  Widget build(BuildContext context) {
    return FTile(
      selected: controller().isUtilitySelectedForPower,
      title: Text(
        'Utility   ${controller().time}',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Row(
            children: [
              Text('Voltage from Utility: '),
              Badge(
                label: controller().voltage.text(),
                backgroundColor: Colors.green,
              ),
              Text(' V'),
            ],
          ),
          Row(
            children: [
              Text('Current drawn: '),
              Badge(
                label: controller().current.text(),
                backgroundColor: Colors.red,
              ),
              Text(' A'),
            ],
          ),
          'Loads: ${controller().loads} W'.text(),
          'EnergyConsumed: ${controller().energyUsedFromUtility} W-secs'.text(),
          'EnergyConsumed: ${(controller().energyUsedFromUtility / 3600000).toStringAsFixed(3)} kWhrs'
              .text(),
          SizedBox(height: 8),
          FButton.icon(
            onPress: controller.onTimeBought,
            child: 'Buy Time (50)'.text(),
          ),
          FButton.icon(
            onPress: controller.onDebtsCleared,
            child: 'Clear Debts (${controller().currentDebt})'.text(),
          ),
        ],
      ),
      suffix: UtilityToggleButton(),
    );
  }
}
