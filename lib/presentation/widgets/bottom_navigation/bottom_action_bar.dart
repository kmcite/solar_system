import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // Add device dialog (redirect to home screen)
              Navigator.of(context).pushNamed('/home');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Device',
          ),
          const Spacer(),
          Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              final totalConsumption = homeProvider.totalConsumption;
              return Text(
                'Total: ${totalConsumption.toStringAsFixed(0)}W',
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Reset system
              _showResetDialog(context);
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset System',
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset System'),
        content: const Text('Are you sure you want to reset all system data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Reset home provider devices
              context.read<HomeProvider>().resetDevices();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
