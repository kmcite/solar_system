import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/inverter_repository_impl.dart';
import '../common/base_tile.dart';
import '../controls/inverter_mode_toggle.dart';
import '../controls/inverter_voltage_toggle.dart';
import '../controls/flow_bar.dart';

class InverterTile extends StatelessWidget {
  const InverterTile({super.key});

  @override
  Widget build(BuildContext context) {
    final inverterRepo = context.watch<InverterRepositoryImpl>();
    final inverter = inverterRepo.inverter;
    final power = inverterRepo.power;
    final current = inverterRepo.current;

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
  }
}
