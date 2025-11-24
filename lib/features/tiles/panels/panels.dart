import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/features/tiles/panels/metric_card.dart';
import 'package:solar_system/utils/router.dart';
import '../../../domain/entities/panels.dart';
import '../../../domain/repositories/panels_repository.dart';
import '../../controls/panel_list.dart';
import '../../controls/add_panel_dialog.dart';
import '../../common/base_tile.dart';

/// Provider that manages solar panels state
class PanelsProvider extends ChangeNotifier {
  late final IPanelsRepository _panelsRepository = find<IPanelsRepository>();
  Panels _panels = Panels();
  bool _isLoading = false;
  String? _error;

  PanelsProvider() {
    _loadPanels();
  }

  // Getters
  Panels get panels => _panels;
  List<Panel> get panelList => _panels.panels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get totalOutput => _panels.totalOutput;
  double get efficiency => _panels.efficiency;
  int get activeCount => _panels.activeCount;

  /// Load panels from repository
  Future<void> _loadPanels() async {
    _setLoading(true);
    try {
      _panels = await _panelsRepository.getPanels();
      _clearError();
    } catch (e) {
      _setError('Failed to load panels: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh panels from repository
  Future<void> refreshPanels() => _loadPanels();

  /// Add new panel
  Future<void> addPanel(Panel panel) async {
    try {
      _setLoading(true);
      await _panelsRepository.addPanel(panel);
      _clearError();
    } catch (e) {
      _setError('Failed to add panel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Remove panel
  Future<void> removePanel(String panelId) async {
    try {
      _setLoading(true);
      await _panelsRepository.removePanel(panelId);
      _clearError();
    } catch (e) {
      _setError('Failed to remove panel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update individual panel
  Future<void> updatePanel(Panel panel) async {
    try {
      _setLoading(true);
      await _panelsRepository.updatePanel(panel);
      _clearError();
    } catch (e) {
      _setError('Failed to update panel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle panel active state
  Future<void> togglePanel(String panelId) async {
    final panel = _panels.panels.firstWhere((p) => p.id == panelId);
    final updatedPanel = panel.copyWith(isActive: !panel.isActive);
    await updatePanel(updatedPanel);
  }

  /// Show panel management dialog
  void showPanelManagementDialog(BuildContext context) {
    context.toDialog(
      AlertDialog(
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
              context.toDialog(const AddPanelDialog());
            },
            child: const Text('Add Panel'),
          ),
        ],
      ),
    );
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error state
  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  /// Clear error state
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// View for displaying solar panels tile
class PanelsView extends StatelessWidget {
  const PanelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => PanelsProvider(),
      builder: (_, panelsProvider) {
        if (panelsProvider.isLoading) {
          return BaseTile(
            title: 'Solar Panels',
            icon: Icons.wb_sunny,
            iconColor: Colors.orange,
            children: const [
              CircularProgressIndicator(),
            ],
          );
        }

        if (panelsProvider.error != null) {
          return BaseTile(
            title: 'Solar Panels',
            icon: Icons.wb_sunny,
            iconColor: Colors.orange,
            children: [
              Text('Error loading panels'),
              Text(panelsProvider.error!),
            ],
          );
        }

        final totalOutput = panelsProvider.totalOutput;
        final activeCount = panelsProvider.activeCount;
        final efficiency = panelsProvider.efficiency;

        return BaseTile(
          title: 'Solar Panels',
          icon: Icons.wb_sunny,
          iconColor: Colors.orange,
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => context.toDialog(const AddPanelDialog()),
                icon: const Icon(Icons.add),
                tooltip: 'Add Panel',
              ),
              IconButton(
                onPressed: () =>
                    panelsProvider.showPanelManagementDialog(context),
                icon: const Icon(Icons.list),
                tooltip: 'Manage Panels',
              ),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricCard(
                  title: 'Active',
                  value: '$activeCount',
                  icon: Icons.power,
                  color: Colors.green,
                ),
                MetricCard(
                  title: 'Output',
                  value: '${totalOutput.toStringAsFixed(0)}W',
                  icon: Icons.electrical_services,
                  color: Colors.blue,
                ),
                MetricCard(
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${efficiency.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: efficiency > 70 ? Colors.green : Colors.orange,
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
            if (panelsProvider.panels.panels.isNotEmpty) ...[
              Text(
                'Max Capacity: ${panelsProvider.panels.maxOutput.toStringAsFixed(0)}W',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Average Panel Output: ${panelsProvider.panels.panels.isEmpty ? 0 : (totalOutput / panelsProvider.panels.panels.length).toStringAsFixed(0)}W',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
