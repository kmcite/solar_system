import 'package:solar_system/domain/apis/loads_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/navigator.dart';

import '../../../domain/models/load.dart';

Load _load = Fan();
void _nameChanged(String value) {
  _load.name = value;
}

void _powerUsageChanged(String value) {
  // _load.powerUsage = double.tryParse(value) ?? 0;
}

void _put(Load load) {
  loadsRepository.put(load);
  // batteryRepository.setDischargingPower(load.powerUsage);
  // _load = Load(); // Reset the load after adding
}

class AddLoadDialog extends GUI {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: _load.name,
            onChanged: _nameChanged,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Load Name',
              hintText: 'Enter load name',
            ),
          ).pad(),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Power Usage',
              hintText: 'Enter power usage in watts',
              suffixText: 'W',
              border: const OutlineInputBorder(),
            ),
            initialValue: _load.power.powerUsage.toString(),
            onChanged: _powerUsageChanged,
          ).pad(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  _put(_load);
                  navigator.back();
                },
                child: const Text('Save'),
              ).pad(),
              FilledButton(
                onPressed: navigator.back,
                child: const Text('No'),
              ).pad(),
            ],
          ).pad(),
        ],
      ).pad(),
    );
  }
}
