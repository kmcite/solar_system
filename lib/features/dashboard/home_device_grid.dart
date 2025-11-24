import 'package:flutter/material.dart';
import '../../domain/entities/home_device.dart';

/// Grid widget for displaying home devices
class HomeDeviceGrid extends StatelessWidget {
  final List<HomeDevice> devices;
  final Function(String deviceId) onDeviceToggle;

  const HomeDeviceGrid({
    super.key,
    required this.devices,
    required this.onDeviceToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No devices added yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first device',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return HomeDeviceCard(
          device: device,
          onToggle: () => onDeviceToggle(device.id),
        );
      },
    );
  }
}

/// Card widget for individual home device
class HomeDeviceCard extends StatelessWidget {
  final HomeDevice device;
  final VoidCallback onToggle;

  const HomeDeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = device.isActive && device.powerConsumption > 0;

    return Card(
      elevation: 2,
      color: isActive
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device icon and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    device.icon,
                    size: 24,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Device name
              Text(
                device.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Device type
              Text(
                device.typeDisplayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Power consumption
              Row(
                children: [
                  Icon(
                    Icons.power,
                    size: 16,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${device.powerConsumption.toStringAsFixed(0)}W',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
