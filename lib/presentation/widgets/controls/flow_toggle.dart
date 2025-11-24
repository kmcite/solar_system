import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/flow_repository_impl.dart';

class FlowToggle extends StatelessWidget {
  const FlowToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final flowRepo = context.watch<FlowRepositoryImpl>();
    final flow = flowRepo.flow;
    final isActive = flow.isActive;

    return IconButton(
      onPressed: isActive ? flowRepo.stopFlow : flowRepo.startFlow,
      icon: Icon(
        isActive ? Icons.pause : Icons.play_arrow,
        color: isActive ? Colors.green : Colors.orange,
      ),
      tooltip: isActive ? 'Stop Flow' : 'Start Flow',
    );
  }
}
