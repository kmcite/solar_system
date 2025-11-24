import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/inverter.dart';
import '../../domain/repositories/inverter_repository.dart';
import '../common/base_tile.dart';
import '../controls/inverter_mode_toggle.dart';
import '../controls/inverter_voltage_toggle.dart';
import '../controls/flow_bar.dart';

class InverterTileProvider extends ChangeNotifier {
  late final IInverterRepository _inverterRepository =
      find<IInverterRepository>();
  StreamSubscription<Inverter>? _subscription;

  InverterTileProvider() {
    _subscription = _inverterRepository.watchInverter().listen(
      (inverter) {
        this.inverter = inverter;
        notifyListeners();
      },
    );
  }

  Inverter inverter = Inverter(id: 'id');
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class InverterTile extends StatelessWidget {
  const InverterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => InverterTileProvider(),
      builder: (_, inverterRepo) {
        final inverter = inverterRepo.inverter;
        final power = inverter.outputPower;
        final current = power / inverter.voltage.value;

        return BaseTile(
          title: 'Inverter',
          icon: inverter.isOnline ? Icons.power : Icons.power_off,
          iconColor: inverter.isOnline ? Colors.green : Colors.red,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InverterModeToggle(),
              const SizedBox(width: 8),
              InverterVoltageToggle(),
            ],
          ),
          children: [
            Text('Mode: ${inverter.mode.displayName}'),
            Text('Voltage: ${inverter.voltage.displayName}'),
            Text('Power: ${power.toStringAsFixed(0)}W'),
            Text('Current: ${current.toStringAsFixed(2)}A'),
            const SizedBox(height: 8),
            const FlowBar(),
          ],
        );
      },
    );
  }
}
