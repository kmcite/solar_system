import 'package:solar_system/domain/apis/flow_repository.dart';
import 'package:solar_system/domain/apis/panels_repository.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/main.dart';

import '../../domain/models/battery.dart';

mixin class InverterBloc {
  String get powerBeingProduced {
    if (inverter.isOff) return '0 W';
    return '${(flowRepository.percentage * panelsRepository.powerCapacity).toStringAsFixed(0)} W';
  }

  InverterStatus loadsOn([InverterStatus? value]) {
    if (value != null) {
      inverter.status = value;
      battery..loadOnBattery = value.powerUsage;
    }
    return inverter.status;
  }
}

class InverterTile extends GUI with InverterBloc {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'INVERTER',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Power being produced: $powerBeingProduced'),
          Row(
            children: List.generate(
              InverterStatus.values.length,
              (i) {
                final loadsOn = InverterStatus.values[i];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton.filled(
                    icon: Icon(loadsOn.icon),
                    onPressed: this.loadsOn() == loadsOn
                        ? null
                        : () => this.loadsOn(loadsOn),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
