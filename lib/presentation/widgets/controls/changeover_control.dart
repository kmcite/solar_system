import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/changeover_repository_impl.dart';
import '../../../domain/entities/changeover.dart';

class ChangeoverControl extends StatelessWidget {
  const ChangeoverControl({super.key});

  @override
  Widget build(BuildContext context) {
    final changeoverRepo = context.watch<ChangeoverRepositoryImpl>();
    final isAutoMode = changeoverRepo.isAutoMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: isAutoMode,
          onChanged: (value) {
            changeoverRepo.setAutomaticMode(value);
          },
          activeColor: Colors.blue,
        ),
        const SizedBox(width: 4),
        PopupMenuButton<ChangeoverState>(
          icon: const Icon(Icons.more_vert, size: 16),
          onSelected: (state) {
            changeoverRepo.switchToState(state);
          },
          itemBuilder: (context) => ChangeoverState.values.map((state) {
            return PopupMenuItem(
              value: state,
              child: Row(
                children: [
                  Icon(_getIconForState(state)),
                  const SizedBox(width: 8),
                  Text(state.displayName),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getIconForState(ChangeoverState state) {
    switch (state) {
      case ChangeoverState.utility:
        return Icons.power;
      case ChangeoverState.solar:
        return Icons.wb_sunny;
      case ChangeoverState.backup:
        return Icons.battery_full;
    }
  }
}
