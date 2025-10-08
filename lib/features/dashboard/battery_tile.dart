// import 'package:solar_system/main.dart';
// import 'package:solar_system/v5/colleagues/battery.dart';

import 'package:solar_system/domain/panels_repository.dart';
import 'package:solar_system/domain/battery_repository.dart';
import 'package:solar_system/domain/flow_repository.dart';
import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class BatteryState {
  bool isBatteryMode = false;
  double soc = 0;
  double chargingSpeed = 0;
  double charge = 0;
}

class BatteryBloc extends Cubit<BatteryState> {
  BatteryBloc() : super(BatteryState());
  late BatteryRepository batteryRepository = find();
  late InverterRepository inverterRepository = find();
  late FlowRepository flowRepository = find();
  late PanelsRepository panelsRepository = find();
  @override
  // BatteryState get initialState => BatteryState()
  //   ..isBatteryMode = inverterRepository.isBatteryMode
  //   ..soc = batteryRepository().soc;
  @override
  initState() async {
    inverterRepository.stream.listen((_) {
      final effectivePowerFromPanels = panelsRepository.effectivePower(
        flowRepository().solarFlow,
      );
      final power = inverterRepository.effectivePower(
        effectivePowerFromPanels,
      ); // reactive
      final current = power / batteryRepository().voltage;
      final clampedChargingCurrent = current.clamp(
        0,
        batteryRepository().maximumChargingCurrent,
      );
      final clampedPower = clampedChargingCurrent * batteryRepository().voltage;
      final remainingPower = power - clampedPower;
      batteryRepository.setCharge(remainingPower);
    });
    final power = inverterRepository.effectivePower(flowRepository().solarFlow);
    double amps = power / batteryRepository().voltage;
    if (amps > batteryRepository().maximumChargingCurrent) {
      amps = batteryRepository().maximumChargingCurrent;
    }
    final previous = batteryRepository().charge;
    final newCharge = (previous + amps * batteryRepository().voltage).clamp(
      0,
      batteryRepository().capacity,
    );
    batteryRepository.setCharge(newCharge.toDouble());
  }

  bool get isBatteryMode => inverterRepository.isBatteryMode;

  double get chargingSpeed {
    final solarFlow = flowRepository().solarFlow;
    final solarPower = panelsRepository.effectivePower(solarFlow);
    final fullInverterPower = inverterRepository.effectivePower(solarPower);
    final current = fullInverterPower / batteryRepository().voltage;
    double maxAllowed = current.clamp(
      0,
      batteryRepository().maximumChargingCurrent,
    );
    final chargingSpeed = maxAllowed * batteryRepository().voltage;
    print("chargingSpeed: $chargingSpeed, maxAllowed: $maxAllowed");
    return chargingSpeed;
  }

  double get maximumChargingPower {
    final current = batteryRepository().charge;
    final voltage = batteryRepository().voltage;
    final power = current * voltage;
    if (current >= batteryRepository().maximumChargingCurrent) {
      return batteryRepository().maximumChargingCurrent * voltage;
    }
    return power;
  }

  // double get capacityInKwhr => batteryRepository.capacity / 3600000;
  // double get chargeInKwhr => batteryRepository.charge / 3600000;
  double get soc => batteryRepository().soc;
}

class BatteryTile extends Feature<BatteryBloc> {
  @override
  BatteryBloc create() => BatteryBloc();
  @override
  Widget build(BuildContext context) {
    return FTile(
      title: Text(
        'Battery',
        style: TextStyle(fontSize: controller().isBatteryMode ? 24 : null),
      ),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${controller().soc} / ${1} KWhr ${controller().charge}'),
          Text('Charging Speed: ${controller().chargingSpeed} W'),
          LinearProgressIndicator(value: controller().soc),
        ],
      ),
    );
  }
}
