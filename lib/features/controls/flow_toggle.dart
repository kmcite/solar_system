import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/solar_flow.dart';
import 'package:solar_system/domain/repositories/flow_repository.dart';

class FlowToggleProvider extends ChangeNotifier {
  late final IFlowRepository _flowRepository = find<IFlowRepository>();
  StreamSubscription<SolarFlow>? _subscription;

  late SolarFlow flow;
  FlowToggleProvider() {
    _subscription = _flowRepository.watch().listen((flow) {
      this.flow = flow;
      notifyListeners();
    });
  }

  void startFlow() => _flowRepository.startFlow();
  void stopFlow() => _flowRepository.stopFlow();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class FlowToggle extends StatelessWidget {
  const FlowToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => FlowToggleProvider(),
      builder: (_, _flowRepo) {
        final flow = _flowRepo.flow;
        final isActive = flow.isActive;
        return IconButton(
          onPressed: isActive ? _flowRepo.stopFlow : _flowRepo.startFlow,
          icon: Icon(
            isActive ? Icons.pause : Icons.play_arrow,
            color: isActive ? Colors.green : Colors.orange,
          ),
          tooltip: isActive ? 'Stop Flow' : 'Start Flow',
        );
      },
    );
  }
}
