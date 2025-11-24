enum ChangeoverState {
  utility,
  solar,
  backup;

  String get displayName {
    switch (this) {
      case ChangeoverState.utility:
        return 'Utility';
      case ChangeoverState.solar:
        return 'Solar';
      case ChangeoverState.backup:
        return 'Backup';
    }
  }
}

/// Changeover entity representing power source switching
class Changeover {
  final String id;
  ChangeoverState currentState;
  ChangeoverState previousState;
  DateTime? lastSwitched;
  bool isAutoMode;
  DateTime? lastUpdated;

  Changeover({
    required this.id,
    this.currentState = ChangeoverState.utility,
    this.previousState = ChangeoverState.utility,
    this.lastSwitched,
    this.isAutoMode = true,
    this.lastUpdated,
  });

  /// Returns whether currently using utility power
  bool get isOnUtility => currentState == ChangeoverState.utility;

  /// Returns whether currently using solar power
  bool get isOnSolar => currentState == ChangeoverState.solar;

  /// Returns whether currently on backup power
  bool get isOnBackup => currentState == ChangeoverState.backup;

  /// Returns whether the system recently switched
  bool get recentlySwitched {
    if (lastSwitched == null) return false;
    final now = DateTime.now();
    return now.difference(lastSwitched!).inMinutes < 1;
  }

  Changeover copyWith({
    String? id,
    ChangeoverState? currentState,
    ChangeoverState? previousState,
    DateTime? lastSwitched,
    bool? isAutoMode,
    DateTime? lastUpdated,
  }) {
    return Changeover(
      id: id ?? this.id,
      currentState: currentState ?? this.currentState,
      previousState: previousState ?? this.previousState,
      lastSwitched: lastSwitched ?? this.lastSwitched,
      isAutoMode: isAutoMode ?? this.isAutoMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Switch to a new state
  Changeover switchTo(ChangeoverState newState) {
    if (newState == currentState) return this;

    return copyWith(
      previousState: currentState,
      currentState: newState,
      lastSwitched: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Changeover(id: $id, state: ${currentState.displayName}, '
        'previous: ${previousState.displayName}, auto: $isAutoMode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Changeover &&
        other.id == id &&
        other.currentState == currentState &&
        other.previousState == previousState &&
        other.isAutoMode == isAutoMode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        currentState.hashCode ^
        previousState.hashCode ^
        isAutoMode.hashCode;
  }
}
