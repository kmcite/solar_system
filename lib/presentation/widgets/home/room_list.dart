import 'package:flutter/material.dart';
import '../../../domain/entities/home_device.dart';
import '../../../domain/entities/home_device.dart' as entities;

/// Widget for displaying rooms and their devices
class RoomList extends StatelessWidget {
  final List<entities.Room> rooms;
  final List<HomeDevice> devices;
  final Function(String deviceId) onDeviceToggle;

  const RoomList({
    super.key,
    required this.rooms,
    required this.devices,
    required this.onDeviceToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: rooms.map((room) {
        final roomDevices = devices
            .where((device) => device.roomId == room.id)
            .toList();
        final roomConsumption = roomDevices
            .where((device) => device.isConsumingPower)
            .fold(0.0, (sum, device) => sum + device.powerConsumption);

        return RoomCard(
          room: room,
          devices: roomDevices,
          totalConsumption: roomConsumption,
          onDeviceToggle: onDeviceToggle,
        );
      }).toList(),
    );
  }
}

/// Card widget for individual room
class RoomCard extends StatelessWidget {
  final entities.Room room;
  final List<HomeDevice> devices;
  final double totalConsumption;
  final Function(String deviceId) onDeviceToggle;

  const RoomCard({
    super.key,
    required this.room,
    required this.devices,
    required this.totalConsumption,
    required this.onDeviceToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeDevices = devices
        .where((device) => device.isConsumingPower)
        .length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getRoomIcon(room.name),
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          room.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.devices,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  '$activeDevices/${devices.length} active',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.power,
                  size: 16,
                  color: totalConsumption > 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  '${totalConsumption.toStringAsFixed(0)}W',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: totalConsumption > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          if (devices.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Devices in ${room.name}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...devices.map((device) => _buildDeviceTile(context, device)),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No devices in this room',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceTile(BuildContext context, HomeDevice device) {
    final theme = Theme.of(context);
    final isActive = device.isConsumingPower;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            device.icon,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            size: 20,
          ),
          title: Text(
            device.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            device.typeDisplayName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${device.powerConsumption.toStringAsFixed(0)}W',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (device.isActive)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Switch(
                value: device.isActive,
                onChanged: (_) => onDeviceToggle(device.id),
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
          onTap: () => onDeviceToggle(device.id),
        ),
      ),
    );
  }

  IconData _getRoomIcon(String roomName) {
    final name = roomName.toLowerCase();

    if (name.contains('living')) {
      return Icons.living;
    } else if (name.contains('kitchen')) {
      return Icons.kitchen;
    } else if (name.contains('bedroom') || name.contains('bed')) {
      return Icons.bed;
    } else if (name.contains('bathroom')) {
      return Icons.bathtub;
    } else if (name.contains('garage')) {
      return Icons.garage;
    } else if (name.contains('office') || name.contains('study')) {
      return Icons.work;
    } else if (name.contains('dining')) {
      return Icons.dining;
    } else {
      return Icons.room;
    }
  }
}
