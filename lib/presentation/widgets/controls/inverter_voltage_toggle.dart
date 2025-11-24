import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/inverter_repository_impl.dart';
import '../../../domain/entities/inverter.dart';

class InverterVoltageToggle extends StatelessWidget {
  const InverterVoltageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final inverterRepo = context.watch<InverterRepositoryImpl>();
    final currentVoltage = inverterRepo.voltage;

    return PopupMenuButton<InverterVoltage>(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          currentVoltage.displayName,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      onSelected: (voltage) {
        inverterRepo.setVoltage(voltage);
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
  }
}
