/// Solar panel entity representing power generation
class Panel {
  final String id;
  double currentOutput;
  double maxOutput;
  bool isActive;
  DateTime? lastUpdated;

  Panel({
    required this.id,
    this.currentOutput = 0.0,
    this.maxOutput = 1000.0,
    this.isActive = true,
    this.lastUpdated,
  });

  /// Returns the current efficiency as a percentage
  double get efficiency =>
      maxOutput > 0 ? (currentOutput / maxOutput) * 100 : 0.0;

  Panel copyWith({
    String? id,
    double? currentOutput,
    double? maxOutput,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return Panel(
      id: id ?? this.id,
      currentOutput: currentOutput ?? this.currentOutput,
      maxOutput: maxOutput ?? this.maxOutput,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Panel(id: $id, currentOutput: ${currentOutput.toStringAsFixed(1)}W, '
        'maxOutput: ${maxOutput.toStringAsFixed(1)}W, efficiency: ${efficiency.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Panel &&
        other.id == id &&
        other.currentOutput == currentOutput &&
        other.maxOutput == maxOutput &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        currentOutput.hashCode ^
        maxOutput.hashCode ^
        isActive.hashCode;
  }
}

/// Collection of solar panels
class Panels {
  final List<Panel> panels;
  final DateTime? lastUpdated;

  Panels({
    this.panels = const [],
    this.lastUpdated,
  });

  /// Total current output from all active panels
  double get totalOutput {
    return panels
        .where((panel) => panel.isActive)
        .fold(0.0, (sum, panel) => sum + panel.currentOutput);
  }

  /// Maximum possible output from all active panels
  double get maxOutput {
    return panels
        .where((panel) => panel.isActive)
        .fold(0.0, (sum, panel) => sum + panel.maxOutput);
  }

  /// Overall efficiency of the panel system
  double get efficiency =>
      maxOutput > 0 ? (totalOutput / maxOutput) * 100 : 0.0;

  /// Number of active panels
  int get activeCount => panels.where((panel) => panel.isActive).length;

  /// Average efficiency across all active panels
  double get averageEfficiency {
    final activePanels = panels.where((panel) => panel.isActive);
    if (activePanels.isEmpty) return 0.0;

    final totalEfficiency = activePanels.fold(
      0.0,
      (sum, panel) => sum + panel.efficiency,
    );
    return totalEfficiency / activePanels.length;
  }

  Panels copyWith({
    List<Panel>? panels,
    DateTime? lastUpdated,
  }) {
    return Panels(
      panels: panels ?? this.panels,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Panels(count: ${panels.length}, activeCount: $activeCount, '
        'totalOutput: ${totalOutput.toStringAsFixed(1)}W, efficiency: ${efficiency.toStringAsFixed(1)}%)';
  }
}
