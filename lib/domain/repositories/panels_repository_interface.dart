import '../entities/panels.dart';

/// Repository interface for panels data access
abstract class PanelsRepositoryInterface {
  /// Get current panels state
  Future<Panels> getPanels();

  /// Update panels state
  Future<void> updatePanels(Panels panels);

  /// Stream panels state changes
  Stream<Panels> watchPanels();

  /// Update individual panel
  Future<void> updatePanel(Panel panel);

  /// Add new panel
  Future<void> addPanel(Panel panel);

  /// Remove panel
  Future<void> removePanel(String panelId);

  /// Get panels history
  Future<List<Panels>> getPanelsHistory({
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });

  /// Reset panels to default state
  Future<void> resetPanels();
}
