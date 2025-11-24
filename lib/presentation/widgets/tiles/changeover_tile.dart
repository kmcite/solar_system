import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/changeover_repository_impl.dart';
import '../../../domain/entities/changeover.dart';
import '../common/base_tile.dart';
import '../controls/changeover_control.dart';

class ChangeoverTile extends StatelessWidget {
  const ChangeoverTile({super.key});

  @override
  Widget build(BuildContext context) {
    final changeoverRepo = context.watch<ChangeoverRepositoryImpl>();
    final changeover = changeoverRepo.changeover;
    final currentSource = changeover.currentState;
    final isAutoMode = changeover.isAutoMode;

    return BaseTile(
      title: 'Power Source',
      icon: _getIconForSource(currentSource),
      iconColor: _getColorForSource(currentSource),
      action: ChangeoverControl(),
      children: [
        Text('Source: ${currentSource.displayName}'),
        Text('Mode: ${isAutoMode ? 'Automatic' : 'Manual'}'),
        if (changeover.recentlySwitched)
          const Text(
            'Recently switched',
            style: TextStyle(color: Colors.orange, fontSize: 12),
          ),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _getProgressForSource(currentSource),
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getColorForSource(currentSource),
              ),
              minHeight: 12,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForSource(ChangeoverState source) {
    switch (source) {
      case ChangeoverState.utility:
        return Icons.power;
      case ChangeoverState.solar:
        return Icons.wb_sunny;
      case ChangeoverState.backup:
        return Icons.battery_full;
    }
  }

  Color _getColorForSource(ChangeoverState source) {
    switch (source) {
      case ChangeoverState.utility:
        return Colors.blue;
      case ChangeoverState.solar:
        return Colors.orange;
      case ChangeoverState.backup:
        return Colors.green;
    }
  }

  double _getProgressForSource(ChangeoverState source) {
    switch (source) {
      case ChangeoverState.utility:
        return 0.33;
      case ChangeoverState.solar:
        return 0.67;
      case ChangeoverState.backup:
        return 1.0;
    }
  }
}
