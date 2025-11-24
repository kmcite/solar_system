import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/repositories/inverter_repository.dart';
import '../../domain/entities/inverter.dart';

class InverterVoltageToggleProvider extends ChangeNotifier {
  late final IInverterRepository _inverterRepository =
      find<IInverterRepository>();
  StreamSubscription<Inverter>? _subscription;

  Inverter _inverter = Inverter(id: 'main_inverter');

  InverterVoltageToggleProvider() {
    _subscription = _inverterRepository.watchInverter().listen((inverter) {
      _inverter = inverter;
      notifyListeners();
    });
  }

  InverterVoltage get currentVoltage => _inverter.voltage;

  void setVoltage(InverterVoltage voltage) {
    _inverterRepository.setVoltage(voltage);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class InverterVoltageToggle extends StatelessWidget {
  const InverterVoltageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => InverterVoltageToggleProvider(),
      builder: (_, provider) {
        final currentVoltage = provider.currentVoltage;

        return PopupMenuButton<InverterVoltage>(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              currentVoltage.displayName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          onSelected: (voltage) {
            provider.setVoltage(voltage);
          },
          itemBuilder: (context) => InverterVoltage.values.map((voltage) {
            return PopupMenuItem(
              value: voltage,
              child: Row(
                children: [
                  Text(voltage.displayName),
                  if (voltage == currentVoltage)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
