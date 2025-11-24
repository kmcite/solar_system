import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../domain/entities/home_device.dart';
import '../widgets/home/home_device_grid.dart';
import '../widgets/home/consumption_summary.dart';
import '../widgets/home/room_list.dart';

/// Home screen showing household electricity consumption
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize home devices if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.deviceList.isEmpty) {
        homeProvider.initializeSampleData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<HomeProvider>(
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
            );
          }

          return RefreshIndicator(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddDeviceDialog(),
    );
  }
}

/// Dialog for adding a new device
class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _nameController = TextEditingController();
  final _powerController = TextEditingController();
  HomeDeviceType _selectedType = HomeDeviceType.other;
  String? _selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return AlertDialog(
          title: const Text('Add Device'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Device Name',
                    hintText: 'e.g., Smart TV',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<HomeDeviceType>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: 'Device Type'),
                  items: HomeDeviceType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(type.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (type) {
                    setState(() {
                      _selectedType = type!;
                      // Auto-fill typical power consumption
                      _powerController.text = type.typicalPowerConsumption
                          .toStringAsFixed(0);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _powerController,
                  decoration: const InputDecoration(
                    labelText: 'Power Consumption (W)',
                    hintText: 'e.g., 150',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (homeProvider.rooms.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _selectedRoomId,
                    decoration: const InputDecoration(
                      labelText: 'Room (Optional)',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No Room'),
                      ),
                      ...homeProvider.rooms.map((room) {
                        return DropdownMenuItem(
                          value: room.id,
                          child: Text(room.name),
                        );
                      }),
                    ],
                    onChanged: (roomId) {
                      setState(() {
                        _selectedRoomId = roomId;
                      });
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addDevice,
              child: const Text('Add Device'),
            ),
          ],
        );
      },
    );
  }

  void _addDevice() {
    final name = _nameController.text.trim();
    final power = double.tryParse(_powerController.text);

    if (name.isNotEmpty && power != null && power > 0) {
      final homeProvider = context.read<HomeProvider>();
      final device = HomeDevice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: _selectedType,
        powerConsumption: power,
        roomId: _selectedRoomId,
      );

      homeProvider.addDevice(device);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _powerController.dispose();
    super.dispose();
  }
}
