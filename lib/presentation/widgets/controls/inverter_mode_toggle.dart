import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/inverter_repository_impl.dart';
import '../../../domain/entities/inverter.dart';

class InverterModeToggle extends StatelessWidget {
  const InverterModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final inverterRepo = context.watch<InverterRepositoryImpl>();
    final currentMode = inverterRepo.mode;

    return PopupMenuButton<InverterMode>(
      icon: Icon(_getIconForMode(currentMode)),
      onSelected: (mode) {
        inverterRepo.setMode(mode);
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
