import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/loads.dart';
import '../../domain/repositories/loads_repository.dart';

class LoadListProvider extends ChangeNotifier {
  late final ILoadsRepository _loadsRepository = find<ILoadsRepository>();
  StreamSubscription<Loads>? _subscription;

  Loads _loads = Loads();

  LoadListProvider() {
    _subscription = _loadsRepository.watchLoads().listen((loads) {
      _loads = loads;
      notifyListeners();
    });
  }

  Loads get loads => _loads;

  void toggleLoad(String loadId) {
    _loadsRepository.toggleLoad(loadId);
  }

  void removeLoad(String loadId) {
    _loadsRepository.removeLoad(loadId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class LoadList extends StatelessWidget {
  const LoadList({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => LoadListProvider(),
      builder: (_, provider) {
        final loads = provider.loads.loads;

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
              onToggle: () => provider.toggleLoad(load.id),
              onRemove: () => provider.removeLoad(load.id),
            );
          }).toList(),
        );
      },
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
