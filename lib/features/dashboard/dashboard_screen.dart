import 'package:flutter/material.dart';
import '../tiles/battery.dart';
import '../tiles/inverter_tile.dart';
import '../tiles/panels/panels.dart';
import '../tiles/changeover_tile.dart';
import '../tiles/utility_tile.dart';
import '../tiles/loads_tile.dart';
import '../bottom_navigation/bottom_action_bar.dart';
import '../../utils/router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar System Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () => context.goToHome(),
            icon: const Icon(Icons.home),
            tooltip: 'Home Devices',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Power System',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Solar System Components
            const Row(
              children: [
                Expanded(child: PanelsView()),
                SizedBox(width: 8),
                Expanded(child: BatteryView()),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: InverterTile()),
                SizedBox(width: 8),
                Expanded(child: ChangeoverTile()),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: UtilityTile()),
                SizedBox(width: 8),
                Expanded(child: LoadsTile()),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => context.goToHome(),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.home, size: 32, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Home Devices'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomActionBar(),
    );
  }
}
