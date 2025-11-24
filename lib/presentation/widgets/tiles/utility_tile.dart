import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/utility_repository_impl.dart';
import '../common/base_tile.dart';
import '../controls/utility_toggle.dart';

class UtilityTile extends StatelessWidget {
  const UtilityTile({super.key});

  @override
  Widget build(BuildContext context) {
    final utilityRepo = context.watch<UtilityRepositoryImpl>();
    final utility = utilityRepo.utility;
    final isOnline = utility.isOnline;
    final netFlow = utility.netFlow;

    return BaseTile(
      title: 'Utility Grid',
      icon: isOnline ? Icons.power : Icons.power_off,
      iconColor: isOnline ? Colors.blue : Colors.grey,
      action: const UtilityToggle(),
      children: [
        Text('Status: ${isOnline ? 'Online' : 'Offline'}'),
        Text('Voltage: ${utility.voltage.toStringAsFixed(0)}V'),
        Text('Frequency: ${utility.frequency.toStringAsFixed(1)}Hz'),
        if (isOnline) ...[
          Text(
            'Net Flow: ${netFlow.toStringAsFixed(0)}W',
            style: TextStyle(
              color: netFlow > 0 ? Colors.red : Colors.green,
            ),
          ),
          if (netFlow > 0)
            const Text(
              'Importing from grid',
              style: TextStyle(color: Colors.red),
            )
          else if (netFlow < 0)
            const Text(
              'Exporting to grid',
              style: TextStyle(color: Colors.green),
            )
          else
            const Text(
              'No grid activity',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ],
    );
  }
}
