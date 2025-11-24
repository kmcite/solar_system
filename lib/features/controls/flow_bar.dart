import 'dart:async';

import 'package:flutter/material.dart' hide Flow;
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/solar_flow.dart';
import 'package:solar_system/domain/repositories/flow_repository.dart';

class FlowBarProvider extends ChangeNotifier {
  late final IFlowRepository _flowRepository = find<IFlowRepository>();
  StreamSubscription<SolarFlow>? _subscription;

  SolarFlow _flow = SolarFlow(id: 'main_flow');

  FlowBarProvider() {
    _subscription = _flowRepository.watchFlow().listen((flow) {
      _flow = flow;
      notifyListeners();
    });
  }

  bool get isActive => _flow.state.isActive;
  double get currentFlow => _flow.currentFlow;

  void startFlow() => _flowRepository.startFlow();
  void stopFlow() => _flowRepository.stopFlow();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class FlowBar extends StatelessWidget {
  const FlowBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => FlowBarProvider(),
      builder: (_, provider) {
        final isActive = provider.isActive;
        final currentFlow = provider.currentFlow;

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
                      onPressed: isActive
                          ? provider.stopFlow
                          : provider.startFlow,
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
      },
    );
  }
}
