enum Flowing {
  stopped,
  running
  ;

  String get displayName {
    switch (this) {
      case Flowing.stopped:
        return 'Stopped';
      case Flowing.running:
        return 'Running';
    }
  }

  bool get isActive => this == Flowing.running;
}

/// Flow entity representing the system flow state
class SolarFlow {
  final String id;
  Flowing state;
  double currentFlow;
  DateTime? lastUpdated;

  SolarFlow({
    required this.id,
    this.state = Flowing.stopped,
    this.currentFlow = 0.0,
    this.lastUpdated,
  });

  /// Returns whether the flow is currently active
  bool get isActive => state.isActive;

  /// Returns whether the flow is stopped
  bool get isStopped => state == Flowing.stopped;

  SolarFlow copyWith({
    String? id,
    Flowing? state,
    double? currentFlow,
    DateTime? lastUpdated,
  }) {
    return SolarFlow(
      id: id ?? this.id,
      state: state ?? this.state,
      currentFlow: currentFlow ?? this.currentFlow,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Flow(id: $id, state: ${state.displayName}, currentFlow: ${currentFlow.toStringAsFixed(2)}A)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SolarFlow &&
        other.id == id &&
        other.state == state &&
        other.currentFlow == currentFlow;
  }

  @override
  int get hashCode {
    return id.hashCode ^ state.hashCode ^ currentFlow.hashCode;
  }
}
