import 'package:solar_system/domain/apis/flow_repository.dart';
import 'package:solar_system/domain/apis/panels_repository.dart';
import 'package:solar_system/domain/apis/settings_repository.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/main.dart';

import '../../domain/models/battery.dart';

String get _powerBeingProduced {
  if (inverterRepository.isOff) return '0 W';
  return '${(flowRepository.percentage * panelsRepository.powerCapacity).toStringAsFixed(0)} W';
}

void _buyInverter() {
  inverterRepository.buyInverter();
  settingsRepository.isRestored = false;
  batteryRepository..chargingPower = 0.0;
}

InverterOperation get _operation => inverterRepository.operation;
InverterStatus get _status => inverterRepository.status;
void _operationPressed(InverterOperation operation) {
  inverterRepository.setOperation(operation);
}

bool _isOperation(InverterOperation operation) {
  return inverterRepository.operation == operation;
}

void _statusPressed(InverterStatus status) {
  inverterRepository.setStatus(status);
}

bool _isStatus(InverterStatus status) {
  return inverterRepository.status == status;
}

class InverterTile extends GUI {
  @override
  Widget build(BuildContext context) {
    if (inverterRepository.isInverterPresent)
      return ListTile(
        title: const Text('INVERTER'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Power being produced: $_powerBeingProduced'),
            Text('${_operation}'),
            Text('${_status}'),
            Divider(),
            Row(
              children: List.generate(
                InverterOperation.values.length,
                (i) {
                  final operation = InverterOperation.values[i];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton.filled(
                      icon: Icon(
                        switch (operation) {
                          InverterOperation.auto => Icons.auto_mode,
                          InverterOperation.manual =>
                            Icons.catching_pokemon,
                        },
                      ),
                      onPressed: _isOperation(operation)
                          ? null
                          : () => _operationPressed(operation),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              children: InverterStatus.values.map(
                (status) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton.filled(
                      icon: Icon(status.icon),
                      onPressed: _isStatus(status)
                          ? null
                          : () => _statusPressed(status),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      );
    else
      return ListTile(
        title: const Text('INVERTER'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('No inverter present'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _buyInverter,
              child: const Text('BUY INVERTER'),
            ),
          ],
        ),
      );
  }
}
