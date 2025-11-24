import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/utility.dart';
import '../../domain/repositories/utility_repository.dart';
import '../common/base_tile.dart';
import '../controls/utility_toggle.dart';

class UtilityTileProvider extends ChangeNotifier {
  late final IUtilityRepository _utilityRepository = find<IUtilityRepository>();
  StreamSubscription<Utility>? _subscription;

  Utility _utility = Utility(id: 'main_utility');

  UtilityTileProvider() {
    _subscription = _utilityRepository.watchUtility().listen((utility) {
      _utility = utility;
      notifyListeners();
    });
  }

  Utility get utility => _utility;
  bool get isOnline => _utility.isOnline;
  double get netFlow => _utility.netFlow;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class UtilityTile extends StatelessWidget {
  const UtilityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => UtilityTileProvider(),
      builder: (_, provider) {
        final utility = provider.utility;
        final isOnline = provider.isOnline;
        final netFlow = provider.netFlow;

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
      },
    );
  }
}
