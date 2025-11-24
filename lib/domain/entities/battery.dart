/// Battery entity representing the energy storage system
class Battery {
  final String id;
  double charge;
  double voltage;
  double maximumChargingCurrent;
  double capacity;
  DateTime? lastUpdated;

  Battery({
    required this.id,
    this.charge = 1800000.0, // Start at 50% charge (1.8MWh of 3.6MWh capacity)
    this.voltage = 48.0,
    this.maximumChargingCurrent = 60.0,
    this.capacity = 3_600_000.0,
    this.lastUpdated,
  });

  /// Current **charging/discharging current** in **amperes (A)**.
  /// - Positive when charging, negative when discharging.
  /// - Read-only property calculated from power flow.
  double get current => charge / voltage;

  /// Current **state of charge** as a **percentage (0-100)**.
  /// - Calculated as `[charge] / [capacity] * 100`.
  /// - Useful for UI display and battery management decisions.
  double get stateOfCharge => (charge / capacity) * 100;

  /// Returns whether the battery is fully charged
  bool get isFullyCharged => charge >= capacity;

  /// Returns whether the battery is completely empty
  bool get isEmpty => charge <= 0;

  /// Creates a copy of this battery with updated values
  Battery copyWith({
    String? id,
    double? charge,
    double? voltage,
    double? maximumChargingCurrent,
    double? capacity,
    DateTime? lastUpdated,
  }) {
    return Battery(
      id: id ?? this.id,
      charge: charge ?? this.charge,
      voltage: voltage ?? this.voltage,
      maximumChargingCurrent:
          maximumChargingCurrent ?? this.maximumChargingCurrent,
      capacity: capacity ?? this.capacity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Battery(charge: ${charge.toStringAsFixed(1)}, voltage: $voltage, '
        'capacity: ${capacity.toStringAsFixed(1)}, stateOfCharge: ${stateOfCharge.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Battery &&
        other.charge == charge &&
        other.voltage == voltage &&
        other.maximumChargingCurrent == maximumChargingCurrent &&
        other.capacity == capacity;
  }

  @override
  int get hashCode {
    return charge.hashCode ^
        voltage.hashCode ^
        maximumChargingCurrent.hashCode ^
        capacity.hashCode;
  }
}
