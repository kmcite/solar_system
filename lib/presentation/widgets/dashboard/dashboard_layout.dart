import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tiles/inverter_tile.dart';
import '../tiles/panels_tile.dart';
import '../tiles/changeover_tile.dart';
import '../tiles/utility_tile.dart';
import '../tiles/battery_tile.dart';
import '../home/home_device_grid.dart';
import '../home/consumption_summary.dart';
import '../home/room_list.dart';
import '../controls/dark_mode_toggle.dart';
import '../controls/flow_toggle.dart';
import '../../providers/home_provider.dart';
import '../../../data/repositories/settings_repository_impl.dart';

/// Tab-based dashboard layout widget
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Initialize home devices if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.deviceList.isEmpty) {
        homeProvider.initializeSampleData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.wb_sunny),
              text: 'Panels',
            ),
            Tab(
              icon: Icon(Icons.battery_full),
              text: 'Storage',
            ),
            Tab(
              icon: Icon(Icons.settings_input_component),
              text: 'Inverter',
            ),
            Tab(
              icon: Icon(Icons.electrical_services),
              text: 'Distribution',
            ),
            Tab(
              icon: Icon(Icons.home),
              text: 'Smart Home',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.outline,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Solar Panels Tab
              PanelsTab(),

              // Energy Storage Tab
              EnergyStorageTab(),

              // Inverter Tab
              InverterTab(),

              // Power Distribution Tab
              PowerDistributionTab(),

              // Smart Home Tab
              SmartHomeTab(),

              // Settings Tab
              SettingsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Solar Panels Tab - Contains panels management
class PanelsTab extends StatelessWidget {
  const PanelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const PanelsTile(),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => tiles[index],
      itemCount: tiles.length,
    );
  }
}

/// Inverter Tab - Contains inverter management
class InverterTab extends StatelessWidget {
  const InverterTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const InverterTile(),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => tiles[index],
      itemCount: tiles.length,
    );
  }
}

/// Energy Storage Tab - Contains Battery
class EnergyStorageTab extends StatelessWidget {
  const EnergyStorageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const BatteryTile(),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => tiles[index],
      itemCount: tiles.length,
    );
  }
}

/// Power Distribution Tab - Contains Changeover and Utility
class PowerDistributionTab extends StatelessWidget {
  const PowerDistributionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const ChangeoverTile(),
      const UtilityTile(),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => tiles[index],
      itemCount: tiles.length,
    );
  }
}

/// Smart Home Tab - Contains home device management
class SmartHomeTab extends StatelessWidget {
  const SmartHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (homeProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: homeProvider.refreshDevices,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
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

              const SizedBox(height: 16),

              // Room List
              RoomList(
                rooms: homeProvider.rooms,
                devices: homeProvider.deviceList,
                onDeviceToggle: homeProvider.toggleDevice,
              ),

              const SizedBox(height: 16),

              // All Devices Grid
              HomeDeviceGrid(
                devices: homeProvider.deviceList,
                onDeviceToggle: homeProvider.toggleDevice,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Settings Tab - Contains app settings
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsRepositoryImpl>(
      builder: (context, settingsRepo, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Theme Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dark Mode'),
                        const DarkModeToggle(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // System Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Power Flow'),
                        const FlowToggle(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text('Solar System Manager'),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A comprehensive solar power management system with smart home integration.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
