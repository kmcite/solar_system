import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/features/dashboard/add_device_dialog.dart';
import 'home_provider.dart';
import '../dashboard/home_device_grid.dart';
import 'consumption_summary.dart';
import 'room_list.dart';
import '../../utils/router.dart';

/// Home screen showing household electricity consumption
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () {
        final provider = HomeProvider();
        // Initialize home devices if needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.deviceList.isEmpty) {
            provider.initializeSampleData();
          }
        });
        return provider;
      },
      builder: (_, homeProvider) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Devices'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            leading: IconButton(
              onPressed: () => context.goToDashboard(),
              icon: const Icon(Icons.dashboard),
              tooltip: 'Dashboard',
            ),
          ),
          body: Column(
            children: [
              if (homeProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (homeProvider.error != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading home devices',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        homeProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => homeProvider.refreshDevices(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else
                RefreshIndicator(
                  onRefresh: () => homeProvider.refreshDevices(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Consumption Summary
                        ConsumptionSummary(
                          totalConsumption: homeProvider.totalConsumption,
                          activeDevices: homeProvider.activeCount,
                          totalDevices: homeProvider.deviceList.length,
                        ),

                        const SizedBox(height: 24),

                        // Room-wise breakdown
                        if (homeProvider.rooms.isNotEmpty) ...[
                          Text(
                            'Rooms',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          RoomList(
                            rooms: homeProvider.rooms,
                            devices: homeProvider.deviceList,
                            onDeviceToggle: homeProvider.toggleDevice,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // All devices grid
                        Text(
                          'All Devices',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        HomeDeviceGrid(
                          devices: homeProvider.deviceList,
                          onDeviceToggle: homeProvider.toggleDevice,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDeviceDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddDeviceDialog(),
    );
  }
}
