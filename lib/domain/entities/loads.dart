/// Load entity representing power consumption
class Load {
  final String id;
  String name;
  double powerConsumption;
  bool isActive;
  DateTime? lastUpdated;

  Load({
    required this.id,
    required this.name,
    this.powerConsumption = 0.0,
    this.isActive = true,
    this.lastUpdated,
  });

  Load copyWith({
    String? id,
    String? name,
    double? powerConsumption,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return Load(
      id: id ?? this.id,
      name: name ?? this.name,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Load(id: $id, name: $name, power: ${powerConsumption.toStringAsFixed(1)}W, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Load &&
        other.id == id &&
        other.name == name &&
        other.powerConsumption == powerConsumption &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        powerConsumption.hashCode ^
        isActive.hashCode;
  }
}

/// Collection of loads
class Loads {
  final List<Load> loads;
  final DateTime? lastUpdated;

  Loads({
    this.loads = const [],
    this.lastUpdated,
  });

  /// Total power consumption from all active loads
  double get totalConsumption {
    return loads
        .where((load) => load.isActive)
        .fold(0.0, (sum, load) => sum + load.powerConsumption);
  }

  /// Number of active loads
  int get activeCount => loads.where((load) => load.isActive).length;

  /// Average power consumption per active load
  double get averageConsumption {
    final activeLoads = loads.where((load) => load.isActive);
    if (activeLoads.isEmpty) return 0.0;
    return totalConsumption / activeLoads.length;
  }

  Loads copyWith({
    List<Load>? loads,
    DateTime? lastUpdated,
  }) {
    return Loads(
      loads: loads ?? this.loads,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Loads(count: ${loads.length}, activeCount: $activeCount, '
        'totalConsumption: ${totalConsumption.toStringAsFixed(1)}W)';
  }
}
