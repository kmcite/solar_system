import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/loads.dart';
import '../../domain/repositories/loads_repository.dart';
import '../common/base_tile.dart';
import '../controls/load_list.dart';

class LoadsTileProvider extends ChangeNotifier {
  late final ILoadsRepository _loadsRepository = find<ILoadsRepository>();
  StreamSubscription? _subscription;

  Loads _loads = Loads();

  LoadsTileProvider() {
    _subscription = _loadsRepository.watch().listen((loads) {
      _loads = loads;
      notifyListeners();
    });
  }

  Loads get loads => _loads;
  double get totalConsumption => _loads.totalConsumption;
  int get activeCount => _loads.activeCount;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class LoadsTile extends StatelessWidget {
  const LoadsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => LoadsTileProvider(),
      builder: (_, loadsProvider) {
        final activeCount = loadsProvider.activeCount;
        final totalConsumption = loadsProvider.totalConsumption;

        return BaseTile(
          title: 'Loads',
          icon: Icons.electrical_services,
          iconColor: Colors.purple,
          children: [
            Text('Active Loads: $activeCount'),
            Text('Total Consumption: ${totalConsumption.toStringAsFixed(0)}W'),
            const SizedBox(height: 8),
            const LoadList(),
          ],
        );
      },
    );
  }
}
