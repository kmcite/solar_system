import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/panels.dart';
import '../tiles/panels/panels.dart';

/// Individual panel grid item widget
class PanelGridItem extends StatelessWidget {
  final Panel panel;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const PanelGridItem({
    super.key,
    required this.panel,
    required this.onToggle,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: panel.isActive
                        ? Colors.orange
                        : Theme.of(context).colorScheme.outline,
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'remove':
                          onRemove();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16),
                            SizedBox(width: 8),
                            Text('Remove'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                panel.id,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${panel.currentOutput.toStringAsFixed(1)}W / ${panel.maxOutput.toStringAsFixed(0)}W',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: panel.maxOutput > 0
                    ? panel.currentOutput / panel.maxOutput
                    : 0,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  panel.isActive ? Colors.orange : Colors.grey,
                ),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying and managing individual panels
class PanelList extends StatelessWidget {
  const PanelList({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => PanelsProvider(),
      builder: (_, panelsProvider) {
        if (panelsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (panelsProvider.error != null) {
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
                  'Error: ${panelsProvider.error}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        final panels = panelsProvider.panelList;

        if (panels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No panels added yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first solar panel to start generating power',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
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
          itemCount: panels.length,
          itemBuilder: (context, index) {
            final panel = panels[index];
            return PanelGridItem(
              panel: panel,
              onToggle: () => panelsProvider.togglePanel(panel.id),
              onRemove: () => _showRemoveDialog(context, panel, panelsProvider),
              onEdit: () => _showEditDialog(context, panel, panelsProvider),
            );
          },
        );
      },
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    Panel panel,
    PanelsProvider panelsProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Panel'),
        content: Text('Are you sure you want to remove panel "${panel.id}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              panelsProvider.removePanel(panel.id);
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
    PanelsProvider panelsProvider,
  ) {
    final currentOutputController = TextEditingController(
      text: panel.currentOutput.toString(),
    );
    final maxOutputController = TextEditingController(
      text: panel.maxOutput.toString(),
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
                hintText: 'e.g., 750',
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
                panelsProvider.updatePanel(
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
