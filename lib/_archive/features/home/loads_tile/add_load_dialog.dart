import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/_archive/domain/apis/loads_repository.dart';
import 'package:solar_system/main.dart';

import '../../../domain/models/load.dart';

final powerRM = signal(0.0);
final nameRM = signal('');

void save() {
  final load = Load()
    ..name = nameRM()
    ..power = powerRM();
  loadsRepository.put(load);
  navigator.back();
}

void nameChanged(String name) {
  nameRM.value = name;
}

void powerChanged(String value) {
  powerRM.value = double.tryParse(value) ?? 0;
}

class AddLoadDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: nameRM.value,
            onChanged: nameChanged,
            decoration: InputDecoration(
              labelText: 'Load Name',
              hintText: 'Enter load name',
            ),
          ).pad(),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Power Usage',
              hintText: 'Enter power usage in watts',
              suffixText: 'W',
            ),
            initialValue: powerRM.toString(),
            onChanged: powerChanged,
          ).pad(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: save,
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
