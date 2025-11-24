import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/flow_repository_impl.dart';

class FlowBar extends StatelessWidget {
  const FlowBar({super.key});

  @override
  Widget build(BuildContext context) {
    final flowRepo = context.watch<FlowRepositoryImpl>();
    final flow = flowRepo.flow;
    final isActive = flow.isActive;
    final currentFlow = flow.currentFlow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isActive ? Icons.play_arrow : Icons.pause,
              size: 16,
              color: isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              'Flow: ${currentFlow.toStringAsFixed(2)}A',
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: isActive ? flowRepo.stopFlow : flowRepo.startFlow,
                  icon: Icon(
                    isActive ? Icons.pause : Icons.play_arrow,
                    size: 16,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: isActive ? currentFlow : 0.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isActive ? Colors.green : Colors.grey,
              ),
              minHeight: 12,
            ),
          ),
        ),
      ],
    );
  }
}
