enum InverterMode {
  solar,
  grid,
  backup;

  String get displayName {
    switch (this) {
      case InverterMode.solar:
        return 'Solar';
      case InverterMode.grid:
        return 'Grid';
      case InverterMode.backup:
        return 'Backup';
    }
  }
}

enum InverterVoltage {
  v12,
  v24,
  v48;

  double get value {
    switch (this) {
      case InverterVoltage.v12:
        return 12.0;
      case InverterVoltage.v24:
        return 24.0;
      case InverterVoltage.v48:
        return 48.0;
    }
  }

  String get displayName {
    switch (this) {
      case InverterVoltage.v12:
        return '12V';
      case InverterVoltage.v24:
        return '24V';
      case InverterVoltage.v48:
        return '48V';
    }
  }
}

/// Inverter entity representing the power conversion system
class Inverter {
  final String id;
  InverterMode mode;
  InverterVoltage voltage;
  double outputPower;
  bool isOnline;
  DateTime? lastUpdated;

  Inverter({
    required this.id,
    this.mode = InverterMode.solar,
    this.voltage = InverterVoltage.v48,
    this.outputPower = 0.0,
    this.isOnline = true,
    this.lastUpdated,
  });

  /// Returns whether the inverter is in solar mode
  bool get isSolarMode => mode == InverterMode.solar;

  /// Returns whether the inverter is operational
  bool get isOperational => isOnline && outputPower >= 0;

  Inverter copyWith({
    String? id,
    InverterMode? mode,
    InverterVoltage? voltage,
    double? outputPower,
    bool? isOnline,
    DateTime? lastUpdated,
  }) {
    return Inverter(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      voltage: voltage ?? this.voltage,
      outputPower: outputPower ?? this.outputPower,
      isOnline: isOnline ?? this.isOnline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Inverter(id: $id, mode: ${mode.displayName}, voltage: ${voltage.displayName}, '
        'outputPower: ${outputPower.toStringAsFixed(1)}W, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Inverter &&
        other.id == id &&
        other.mode == mode &&
        other.voltage == voltage &&
        other.outputPower == outputPower &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mode.hashCode ^
        voltage.hashCode ^
        outputPower.hashCode ^
        isOnline.hashCode;
  }
}
