import 'dart:async';
import 'package:flutter/foundation.dart';
import '../entities/settings.dart';

/// Repository interface for settings data access
abstract class ISettingsRepository {
  /// Get current app settings
  Future<AppSettings> getSettings();

  /// Update app settings
  Future<void> updateSettings(AppSettings settings);

  /// Stream settings changes
  Stream<AppSettings> watchSettings();

  /// Update specific setting
  Future<void> updateSetting<T>(String key, T value);

  /// Reset settings to defaults
  Future<void> resetSettings();

  /// Export settings
  Future<Map<String, dynamic>> exportSettings();

  /// Import settings
  Future<void> importSettings(Map<String, dynamic> settings);
}

/// Implementation of SettingsRepository using in-memory storage
class SettingsRepository extends ChangeNotifier implements ISettingsRepository {
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
    notifyListeners();
  }

  @override
  Stream<AppSettings> watchSettings() {
    return Stream.fromIterable([_settings]).asyncMap((_) async => _settings);
  }

  @override
  Future<void> updateSetting<T>(String key, T value) async {
    AppSettings updatedSettings;

    switch (key) {
      case 'darkMode':
        updatedSettings = _settings.copyWith(darkMode: value as bool);
        break;
      case 'notificationsEnabled':
        updatedSettings = _settings.copyWith(
          notificationsEnabled: value as bool,
        );
        break;
      case 'language':
        updatedSettings = _settings.copyWith(language: value as String);
        break;
      case 'temperatureUnit':
        updatedSettings = _settings.copyWith(temperatureUnit: value as double);
        break;
      case 'autoPowerManagement':
        updatedSettings = _settings.copyWith(
          autoPowerManagement: value as bool,
        );
        break;
      case 'batteryLowThreshold':
        updatedSettings = _settings.copyWith(
          batteryLowThreshold: value as double,
        );
        break;
      case 'batteryHighThreshold':
        updatedSettings = _settings.copyWith(
          batteryHighThreshold: value as double,
        );
        break;
      default:
        throw ArgumentError('Unknown setting key: $key');
    }

    await updateSettings(updatedSettings);
  }

  @override
  Future<void> resetSettings() async {
    _settings = AppSettings(id: 'app_settings');
    _addToHistory(_settings);
    notifyListeners();
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
    await updateSetting('darkMode', !_settings.darkMode);
  }

  void _addToHistory(AppSettings settings) {
    _history.add(settings);

    // Keep only last 100 entries to prevent memory issues
    if (_history.length > 100) {
      _history.removeRange(0, _history.length - 100);
    }
  }
}
