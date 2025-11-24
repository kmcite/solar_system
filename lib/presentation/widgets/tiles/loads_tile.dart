import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/loads_repository_impl.dart';
import '../common/base_tile.dart';
import '../controls/load_list.dart';

class LoadsTile extends StatelessWidget {
  const LoadsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final loadsRepo = context.watch<LoadsRepositoryImpl>();
    final loads = loadsRepo.loads; // This is List<Load>
    final totalConsumption =
        loadsRepo.totalConsumption; // Use repository getter
    final activeCount = loads
        .where((load) => load.isActive)
        .length; // Calculate manually

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
  }
}
