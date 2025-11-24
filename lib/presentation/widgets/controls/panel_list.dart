import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/panels_repository_impl.dart';
import '../../../domain/entities/panels.dart';

/// Widget for displaying and managing individual panels
class PanelList extends StatelessWidget {
  const PanelList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PanelsRepositoryImpl>(
      builder: (context, panelsRepo, child) {
        return FutureBuilder<Panels>(
          future: panelsRepo.getPanels(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final panels = snapshot.data!.panels;

              if (panels.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No panels added yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your first solar panel to start generating power',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: panels.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final panel = panels[index];
                  return PanelItem(
                    panel: panel,
                    onToggle: () => panelsRepo.updatePanel(
                      panel.copyWith(isActive: !panel.isActive),
                    ),
                    onRemove: () =>
                        _showRemoveDialog(context, panel, panelsRepo),
                    onEdit: () => _showEditDialog(context, panel, panelsRepo),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    Panel panel,
    PanelsRepositoryImpl panelsRepo,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Panel'),
        content: Text('Are you sure you want to remove Panel ${panel.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              panelsRepo.removePanel(panel.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    Panel panel,
    PanelsRepositoryImpl panelsRepo,
  ) {
    final maxOutputController = TextEditingController(
      text: panel.maxOutput.toString(),
    );
    final currentOutputController = TextEditingController(
      text: panel.currentOutput.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Panel ${panel.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentOutputController,
              decoration: const InputDecoration(
                labelText: 'Current Output (W)',
                hintText: 'e.g., 800',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxOutputController,
              decoration: const InputDecoration(
                labelText: 'Max Output (W)',
                hintText: 'e.g., 1000',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final currentOutput = double.tryParse(
                currentOutputController.text,
              );
              final maxOutput = double.tryParse(maxOutputController.text);

              if (currentOutput != null && maxOutput != null && maxOutput > 0) {
                panelsRepo.updatePanel(
                  panel.copyWith(
                    currentOutput: currentOutput,
                    maxOutput: maxOutput,
                    lastUpdated: DateTime.now(),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Individual panel item widget
class PanelItem extends StatelessWidget {
  final Panel panel;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const PanelItem({
    super.key,
    required this.panel,
    required this.onToggle,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with panel info and controls
            Row(
              children: [
                // Panel icon and status
                Icon(
                  panel.isActive ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                  color: panel.isActive ? Colors.orange : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                // Panel info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panel ${panel.id}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        panel.isActive ? 'Active' : 'Inactive',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: panel.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Control buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Edit Panel',
                    ),
                    IconButton(
                      onPressed: onToggle,
                      icon: Icon(
                        panel.isActive
                            ? Icons.power_settings_new
                            : Icons.power_off,
                        color: panel.isActive ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      tooltip: panel.isActive ? 'Deactivate' : 'Activate',
                    ),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete, size: 20),
                      tooltip: 'Remove Panel',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Performance metrics
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Current',
                    value: '${panel.currentOutput.toStringAsFixed(0)}W',
                    icon: Icons.electrical_services,
                    iconColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: 'Maximum',
                    value: '${panel.maxOutput.toStringAsFixed(0)}W',
                    icon: Icons.speed,
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: 'Efficiency',
                    value: '${panel.efficiency.toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    iconColor: panel.efficiency > 70
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Efficiency bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: panel.efficiency / 100.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        panel.efficiency > 70 ? Colors.green : Colors.orange,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small metric display card
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
