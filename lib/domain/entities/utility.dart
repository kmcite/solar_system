/// Utility entity representing grid power
class Utility {
  final String id;
  bool isOnline;
  double currentImport;
  double currentExport;
  double voltage;
  double frequency;
  DateTime? lastUpdated;

  Utility({
    required this.id,
    this.isOnline = false,
    this.currentImport = 0.0,
    this.currentExport = 0.0,
    this.voltage = 230.0,
    this.frequency = 50.0,
    this.lastUpdated,
  });

  /// Net power flow (positive = import, negative = export)
  double get netFlow => currentImport - currentExport;

  /// Returns whether currently importing from grid
  bool get isImporting => isOnline && currentImport > 0;

  /// Returns whether currently exporting to grid
  bool get isExporting => isOnline && currentExport > 0;

  /// Returns whether there's no grid activity
  bool get isIdle => !isOnline || (currentImport == 0 && currentExport == 0);

  Utility copyWith({
    String? id,
    bool? isOnline,
    double? currentImport,
    double? currentExport,
    double? voltage,
    double? frequency,
    DateTime? lastUpdated,
  }) {
    return Utility(
      id: id ?? this.id,
      isOnline: isOnline ?? this.isOnline,
      currentImport: currentImport ?? this.currentImport,
      currentExport: currentExport ?? this.currentExport,
      voltage: voltage ?? this.voltage,
      frequency: frequency ?? this.frequency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Utility(id: $id, online: $isOnline, import: ${currentImport.toStringAsFixed(1)}W, '
        'export: ${currentExport.toStringAsFixed(1)}W, voltage: ${voltage.toStringAsFixed(1)}V)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Utility &&
        other.id == id &&
        other.isOnline == isOnline &&
        other.currentImport == currentImport &&
        other.currentExport == currentExport &&
        other.voltage == voltage &&
        other.frequency == frequency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isOnline.hashCode ^
        currentImport.hashCode ^
        currentExport.hashCode ^
        voltage.hashCode ^
        frequency.hashCode;
  }
}
