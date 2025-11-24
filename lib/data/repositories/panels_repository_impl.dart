import 'package:flutter/foundation.dart';
import '../../domain/entities/panels.dart';
import '../../domain/repositories/panels_repository_interface.dart';

/// Implementation of PanelsRepository using in-memory storage
class PanelsRepositoryImpl extends ChangeNotifier
    implements PanelsRepositoryInterface {
  Panels _panels = _createSamplePanels();
  final List<Panels> _history = [];

  @override
  Future<Panels> getPanels() async {
    return _panels;
  }

  @override
  Future<void> updatePanels(Panels panels) async {
    _panels = panels.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_panels);
    notifyListeners();
  }

  @override
  Stream<Panels> watchPanels() {
    return Stream.fromIterable([_panels]).asyncMap((_) async => _panels);
  }

  @override
  Future<void> updatePanel(Panel panel) async {
    final updatedPanels = _panels.copyWith(
      panels: _panels.panels.map((p) => p.id == panel.id ? panel : p).toList(),
      lastUpdated: DateTime.now(),
    );
    await updatePanels(updatedPanels);
  }

  @override
  Future<void> addPanel(Panel panel) async {
    final updatedPanels = _panels.copyWith(
      panels: [..._panels.panels, panel],
      lastUpdated: DateTime.now(),
    );
    await updatePanels(updatedPanels);
  }

  @override
  Future<void> removePanel(String panelId) async {
    final updatedPanels = _panels.copyWith(
      panels: _panels.panels.where((panel) => panel.id != panelId).toList(),
      lastUpdated: DateTime.now(),
    );
    await updatePanels(updatedPanels);
  }

  @override
  Future<List<Panels>> getPanelsHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    var filteredHistory = _history;

    if (startTime != null) {
      filteredHistory = filteredHistory
          .where((panels) => panels.lastUpdated?.isAfter(startTime) ?? false)
          .toList();
    }

    if (endTime != null) {
      filteredHistory = filteredHistory
          .where((panels) => panels.lastUpdated?.isBefore(endTime) ?? false)
          .toList();
    }

    if (limit != null && limit > 0) {
      filteredHistory = filteredHistory.take(limit).toList();
    }

    return filteredHistory.reversed.toList(); // Most recent first
  }

  @override
  Future<void> resetPanels() async {
    _panels = Panels();
    _addToHistory(_panels);
    notifyListeners();
  }

  // Convenience getters for backward compatibility
  List<Panel> get panels => _panels.panels;
  double get totalPower => _panels.totalOutput;

  void _addToHistory(Panels panels) {
    _history.add(panels);

    // Keep only last 1000 entries to prevent memory issues
    if (_history.length > 1000) {
      _history.removeRange(0, _history.length - 1000);
    }
  }

  /// Create sample panels for demonstration
  static Panels _createSamplePanels() {
    return Panels(
      panels: [
        Panel(
          id: 'panel_1',
          currentOutput: 800.0, // Generating 800W
          maxOutput: 1000.0,
          isActive: true,
        ),
        Panel(
          id: 'panel_2',
          currentOutput: 750.0, // Generating 750W
          maxOutput: 1000.0,
          isActive: true,
        ),
        Panel(
          id: 'panel_3',
          currentOutput: 0.0, // Inactive panel
          maxOutput: 1000.0,
          isActive: false,
        ),
      ],
      lastUpdated: DateTime.now(),
    );
  }
}
