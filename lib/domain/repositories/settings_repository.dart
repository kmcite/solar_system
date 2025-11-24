import 'dart:async';
import '../entities/settings.dart';
import '../../../utils/repository.dart';

/// Repository interface for settings data access
abstract class ISettingsRepository extends Repository<AppSettings> {
  /// Get current app settings
  Future<AppSettings> getSettings();

  /// Update app settings
  Future<void> updateSettings(AppSettings settings);

  /// Update dark mode setting
  Future<void> updateDarkMode(bool value);

  /// Update notifications enabled setting
  Future<void> updateNotificationsEnabled(bool value);

  /// Update language setting
  Future<void> updateLanguage(String value);

  /// Update temperature unit setting
  Future<void> updateTemperatureUnit(double value);

  /// Update auto power management setting
  Future<void> updateAutoPowerManagement(bool value);

  /// Update battery low threshold setting
  Future<void> updateBatteryLowThreshold(double value);

  /// Update battery high threshold setting
  Future<void> updateBatteryHighThreshold(double value);

  /// Reset settings to defaults
  Future<void> resetSettings();

  /// Export settings
  Future<Map<String, dynamic>> exportSettings();

  /// Import settings
  Future<void> importSettings(Map<String, dynamic> settings);
}

/// Implementation of SettingsRepository using in-memory storage
class SettingsRepository extends ISettingsRepository {
  AppSettings _settings = AppSettings(id: 'app_settings');
  final List<AppSettings> _history = [];

  @override
  Future<AppSettings> getSettings() async {
    return _settings;
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings.copyWith(lastUpdated: DateTime.now());
    _addToHistory(_settings);
    notify(_settings);
  }

  @override
  Future<void> updateDarkMode(bool value) async {
    final updatedSettings = _settings.copyWith(darkMode: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateNotificationsEnabled(bool value) async {
    final updatedSettings = _settings.copyWith(notificationsEnabled: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateLanguage(String value) async {
    final updatedSettings = _settings.copyWith(language: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateTemperatureUnit(double value) async {
    final updatedSettings = _settings.copyWith(temperatureUnit: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateAutoPowerManagement(bool value) async {
    final updatedSettings = _settings.copyWith(autoPowerManagement: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateBatteryLowThreshold(double value) async {
    final updatedSettings = _settings.copyWith(batteryLowThreshold: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> updateBatteryHighThreshold(double value) async {
    final updatedSettings = _settings.copyWith(batteryHighThreshold: value);
    await updateSettings(updatedSettings);
  }

  @override
  Future<void> resetSettings() async {
    _settings = AppSettings(id: 'app_settings');
    _addToHistory(_settings);
    notify(_settings);
  }

  @override
  Future<Map<String, dynamic>> exportSettings() async {
    return {
      'darkMode': _settings.darkMode,
      'notificationsEnabled': _settings.notificationsEnabled,
      'language': _settings.language,
      'temperatureUnit': _settings.temperatureUnit,
      'autoPowerManagement': _settings.autoPowerManagement,
      'batteryLowThreshold': _settings.batteryLowThreshold,
      'batteryHighThreshold': _settings.batteryHighThreshold,
    };
  }

  @override
  Future<void> importSettings(Map<String, dynamic> settings) async {
    final importedSettings = AppSettings(
      id: 'app_settings',
      darkMode: settings['darkMode'] ?? false,
      notificationsEnabled: settings['notificationsEnabled'] ?? true,
      language: settings['language'] ?? 'en',
      temperatureUnit: settings['temperatureUnit'] ?? 0.0,
      autoPowerManagement: settings['autoPowerManagement'] ?? true,
      batteryLowThreshold: settings['batteryLowThreshold'] ?? 20.0,
      batteryHighThreshold: settings['batteryHighThreshold'] ?? 80.0,
    );
    await updateSettings(importedSettings);
  }

  // Convenience getters for backward compatibility
  AppSettings get settings => _settings;
  bool get dark => _settings.darkMode;

  Future<void> toggleDark() async {
    await updateDarkMode(!_settings.darkMode);
  }

  void _addToHistory(AppSettings settings) {
    _history.add(settings);

    // Keep only last 100 entries to prevent memory issues
    if (_history.length > 100) {
      _history.removeRange(0, _history.length - 100);
    }
  }
}
