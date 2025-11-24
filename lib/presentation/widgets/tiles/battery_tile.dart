import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/battery_repository_impl.dart';
import '../../../domain/services/power_management_service.dart';
import '../common/base_tile.dart';

class BatteryTile extends StatelessWidget {
  const BatteryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final batteryRepo = context.watch<BatteryRepositoryImpl>();
    final powerService = context.watch<PowerManagementService>();
    final battery = batteryRepo.battery;
    final soc = battery.stateOfCharge / 100.0; // Convert percentage to fraction

    return BaseTile(
      title: 'Battery',
      icon: powerService.isManaging
          ? Icons.battery_charging_full
          : Icons.battery_full,
      iconColor: powerService.isManaging ? Colors.green : Colors.blue,
      action: powerService.isManaging
          ? const Icon(Icons.arrow_downward, color: Colors.green, size: 16)
          : null,
      children: [
        Text('SOC: ${battery.stateOfCharge.toStringAsFixed(0)}%'),
        Text('Voltage: ${battery.voltage.toStringAsFixed(1)}V'),
        Text('Current: ${battery.current.toStringAsFixed(2)}A'),
        if (powerService.isManaging)
          const Text(
            'Charging',
            style: TextStyle(color: Colors.green),
          ),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: soc,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                powerService.isManaging ? Colors.green : Colors.blue,
              ),
              minHeight: 12,
            ),
          ),
        ),
      ],
    );
  }
}
