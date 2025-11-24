import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/loads_repository_impl.dart';
import '../../../domain/entities/loads.dart';

class LoadList extends StatelessWidget {
  const LoadList({super.key});

  @override
  Widget build(BuildContext context) {
    final loadsRepo = context.watch<LoadsRepositoryImpl>();
    final loads = loadsRepo.loads;

    if (loads.isEmpty) {
      return const Text(
        'No loads configured',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      );
    }

    return Column(
      children: loads.map((load) {
        return LoadItem(
          load: load,
          onToggle: () => loadsRepo.toggleLoad(load.id),
          onRemove: () => loadsRepo.removeLoad(load.id),
        );
      }).toList(),
    );
  }
}

class LoadItem extends StatelessWidget {
  final Load load;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const LoadItem({
    super.key,
    required this.load,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            load.isActive ? Icons.power : Icons.power_off,
            size: 16,
            color: load.isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              load.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            '${load.powerConsumption.toStringAsFixed(0)}W',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 8),
          Switch(
            value: load.isActive,
            onChanged: (_) => onToggle(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
        ],
      ),
    );
  }
}
