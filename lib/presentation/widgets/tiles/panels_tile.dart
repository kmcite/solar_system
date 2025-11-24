import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/panels_repository_impl.dart';
import '../../../domain/entities/panels.dart';
import '../common/base_tile.dart';
import '../controls/panel_list.dart';
import '../controls/add_panel_dialog.dart';

class PanelsTile extends StatelessWidget {
  const PanelsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PanelsRepositoryImpl>(
      builder: (context, panelsRepo, child) {
        return FutureBuilder<Panels>(
          future: panelsRepo.getPanels(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final panels = snapshot.data!;
              final totalOutput = panels.totalOutput;
              final activeCount = panels.activeCount;
              final efficiency = panels.efficiency;

              return BaseTile(
                title: 'Solar Panels',
                icon: Icons.wb_sunny,
                iconColor: Colors.orange,
                action: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => showAddPanelDialog(context),
                      icon: const Icon(Icons.add),
                      tooltip: 'Add Panel',
                    ),
                    IconButton(
                      onPressed: () => _showPanelManagementDialog(context),
                      icon: const Icon(Icons.list),
                      tooltip: 'Manage Panels',
                    ),
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetricCard(
                        title: 'Active',
                        value: '$activeCount',
                        icon: Icons.power,
                        color: Colors.green,
                      ),
                      _MetricCard(
                        title: 'Output',
                        value: '${totalOutput.toStringAsFixed(0)}W',
                        icon: Icons.electrical_services,
                        color: Colors.blue,
                      ),
                      _MetricCard(
                        title: 'Efficiency',
                        value: '${efficiency.toStringAsFixed(1)}%',
                        icon: Icons.trending_up,
                        color: efficiency > 70 ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Efficiency bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'System Efficiency',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          Text(
                            '${efficiency.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: efficiency > 70
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                          ),
                        ],
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
                            value: efficiency / 100.0,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              efficiency > 70 ? Colors.green : Colors.orange,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Quick stats
                  if (panels.panels.isNotEmpty) ...[
                    Text(
                      'Max Capacity: ${panels.maxOutput.toStringAsFixed(0)}W',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Average Panel Output: ${panels.panels.isEmpty ? 0 : (totalOutput / panels.panels.length).toStringAsFixed(0)}W',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              );
            } else if (snapshot.hasError) {
              return BaseTile(
                title: 'Solar Panels',
                icon: Icons.wb_sunny,
                iconColor: Colors.orange,
                children: [
                  Text('Error loading panels'),
                  Text(snapshot.error.toString()),
                ],
              );
            } else {
              return BaseTile(
                title: 'Solar Panels',
                icon: Icons.wb_sunny,
                iconColor: Colors.orange,
                children: const [
                  CircularProgressIndicator(),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _showPanelManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Panel Management'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: const PanelList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showAddPanelDialog(context);
            },
            child: const Text('Add Panel'),
          ),
        ],
      ),
    );
  }
}

/// Small metric display widget
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
