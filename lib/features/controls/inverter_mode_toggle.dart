import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/repositories/inverter_repository.dart';
import '../../domain/entities/inverter.dart';

class InverterModeToggleProvider extends ChangeNotifier {
  late final IInverterRepository _inverterRepository =
      find<IInverterRepository>();
  StreamSubscription<Inverter>? _subscription;

  Inverter _inverter = Inverter(id: 'main_inverter');

  InverterModeToggleProvider() {
    _subscription = _inverterRepository.watchInverter().listen((inverter) {
      _inverter = inverter;
      notifyListeners();
    });
  }

  InverterMode get currentMode => _inverter.mode;

  void setMode(InverterMode mode) {
    _inverterRepository.setMode(mode);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class InverterModeToggle extends StatelessWidget {
  const InverterModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => InverterModeToggleProvider(),
      builder: (_, provider) {
        final currentMode = provider.currentMode;

        return PopupMenuButton<InverterMode>(
          icon: Icon(_getIconForMode(currentMode)),
          onSelected: (mode) {
            provider.setMode(mode);
          },
          itemBuilder: (context) => InverterMode.values.map((mode) {
            return PopupMenuItem(
              value: mode,
              child: Row(
                children: [
                  Icon(_getIconForMode(mode)),
                  const SizedBox(width: 8),
                  Text(mode.displayName),
                  if (mode == currentMode)
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

  IconData _getIconForMode(InverterMode mode) {
    switch (mode) {
      case InverterMode.solar:
        return Icons.wb_sunny;
      case InverterMode.grid:
        return Icons.power;
      case InverterMode.backup:
        return Icons.battery_full;
    }
  }
}
