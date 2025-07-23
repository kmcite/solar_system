import 'package:solar_system/_archive/domain/apis/loads_repository.dart';
import 'package:solar_system/_archive/domain/apis/settings_repository.dart';
import 'package:solar_system/_archive/domain/apis/utility_repository.dart';
import 'package:solar_system/_archive/domain/models/inverter.dart';
import 'package:solar_system/main.dart';

int get time => utilityRepository.time();
double get voltage => utilityRepository.voltage();
double get powerUsed => voltage * current;
int get current {
  return isUtilitySelectedForPower ? loadsRepository.allLoads ~/ voltage : 0;
}

bool get isUtilitySelectedForPower {
  return inverter.status() == InverterStatus.utility;
}

double get energyUsedFromUtility {
  return utilityRepository.energyConsumed();
}

double get currentDebt {
  return energyUsedFromUtility * utilityRepository.rate();
}

void clearDebts() {
  money.value -= currentDebt;
  utilityRepository.energyConsumed.value = 0;
}

void buyTime() {
  final timeToUpdate = 50;
  utilityRepository.buy(timeToUpdate);
  money.value += 50;
}

class UtilityTile extends UI {
  @override
  Widget build(BuildContext context) {
    return FTile(
      selected: isUtilitySelectedForPower,
      title: Text(
        'UTILITY   ${time}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Row(
            children: [
              Text('Voltage from Utility: '),
              Badge(label: voltage.text(), backgroundColor: Colors.green),
              Text(' V'),
            ],
          ),
          Row(
            children: [
              Text('Current drawn: '),
              Badge(label: current.text(), backgroundColor: Colors.red),
              Text(' A'),
            ],
          ),
          'Power used here: ${powerUsed} W'.text(),
          'EnergyConsumed: ${energyUsedFromUtility} W-secs'.text(),
          'EnergyConsumed: ${(energyUsedFromUtility / 3600000).toStringAsFixed(3)} kWhrs'
              .text(),
          SizedBox(height: 8),
          FButton.icon(
            onPress: buyTime,
            child: 'buy time (50)'.text(),
          ),
          FButton.icon(
            onPress: clearDebts,
            child: 'clear debts ($currentDebt)'.text(),
          ),
        ],
      ),
      suffix: IconButton(
        onPressed: null,
        icon: Icon(isUtilitySelectedForPower ? Icons.power : Icons.power_off),
      ),
    );
  }
}
