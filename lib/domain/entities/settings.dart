/// App settings entity
class AppSettings {
  final String id;
  bool darkMode;
  bool notificationsEnabled;
  String language;
  double temperatureUnit; // 0.0 for Celsius, 1.0 for Fahrenheit
  bool autoPowerManagement;
  double batteryLowThreshold;
  double batteryHighThreshold;
  DateTime? lastUpdated;

  AppSettings({
    required this.id,
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.language = 'en',
    this.temperatureUnit = 0.0,
    this.autoPowerManagement = true,
    this.batteryLowThreshold = 20.0,
    this.batteryHighThreshold = 80.0,
    this.lastUpdated,
  });

  /// Returns temperature unit as string
  String get temperatureUnitDisplay => temperatureUnit == 0.0 ? '°C' : '°F';

  /// Returns whether battery is considered low
  bool isBatteryLow(double currentLevel) => currentLevel <= batteryLowThreshold;

  /// Returns whether battery is considered high
  bool isBatteryHigh(double currentLevel) =>
      currentLevel >= batteryHighThreshold;

  AppSettings copyWith({
    String? id,
    bool? darkMode,
    bool? notificationsEnabled,
    String? language,
    double? temperatureUnit,
    bool? autoPowerManagement,
    double? batteryLowThreshold,
    double? batteryHighThreshold,
    DateTime? lastUpdated,
  }) {
    return AppSettings(
      id: id ?? this.id,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      autoPowerManagement: autoPowerManagement ?? this.autoPowerManagement,
      batteryLowThreshold: batteryLowThreshold ?? this.batteryLowThreshold,
      batteryHighThreshold: batteryHighThreshold ?? this.batteryHighThreshold,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'AppSettings(id: $id, darkMode: $darkMode, notifications: $notificationsEnabled, '
        'language: $language, autoPower: $autoPowerManagement)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.id == id &&
        other.darkMode == darkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.language == language &&
        other.temperatureUnit == temperatureUnit &&
        other.autoPowerManagement == autoPowerManagement &&
        other.batteryLowThreshold == batteryLowThreshold &&
        other.batteryHighThreshold == batteryHighThreshold;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        darkMode.hashCode ^
        notificationsEnabled.hashCode ^
        language.hashCode ^
        temperatureUnit.hashCode ^
        autoPowerManagement.hashCode ^
        batteryLowThreshold.hashCode ^
        batteryHighThreshold.hashCode;
  }
}
