import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/home_device.dart';
import 'package:solar_system/features/home/home_provider.dart';

/// Dialog for adding a new device
class AddDeviceDialog extends StatelessWidget {
  const AddDeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => HomeProvider(),
      builder: (_, homeProvider) {
        return _AddDeviceDialogView(provider: homeProvider);
      },
    );
  }
}

class _AddDeviceDialogView extends StatefulWidget {
  final HomeProvider provider;

  const _AddDeviceDialogView({required this.provider});

  @override
  State<_AddDeviceDialogView> createState() => _AddDeviceDialogViewState();
}

class _AddDeviceDialogViewState extends State<_AddDeviceDialogView> {
  final _nameController = TextEditingController();
  final _powerController = TextEditingController();
  HomeDeviceType _selectedType = HomeDeviceType.other;
  String? _selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.provider,
      builder: (context, child) {
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
                    hintText: 'e.g., TV',
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
                if (widget.provider.rooms.isNotEmpty)
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
                      ...widget.provider.rooms.map((room) {
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
      final device = HomeDevice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: _selectedType,
        powerConsumption: power,
        roomId: _selectedRoomId,
      );

      widget.provider.addDevice(device);
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
