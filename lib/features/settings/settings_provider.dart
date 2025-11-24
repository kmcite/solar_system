import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Provider for settings screen state management
class SettingsScreenProvider extends ChangeNotifier {
  late final ISettingsRepository _settingsRepository;
  bool _isLoading = false;
  String? _error;
  AppSettings _currentSettings = AppSettings(id: 'app_settings');

  SettingsScreenProvider() {
    _settingsRepository = find<ISettingsRepository>();
    _loadSettings();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppSettings get settings => _currentSettings;

  // Settings getters for convenience
  bool get darkMode => settings.darkMode;
  bool get notificationsEnabled => settings.notificationsEnabled;
  String get language => settings.language;
  double get temperatureUnit => settings.temperatureUnit;
  bool get autoPowerManagement => settings.autoPowerManagement;
  double get batteryLowThreshold => settings.batteryLowThreshold;
  double get batteryHighThreshold => settings.batteryHighThreshold;

  Future<void> _loadSettings() async {
    try {
      _setLoading(true);
      _currentSettings = await _settingsRepository.getSettings();
      _clearError();
    } catch (e) {
      _setError('Failed to load settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateDarkMode(bool value) async {
    await _updateSetting('darkMode', value);
  }

  Future<void> updateNotificationsEnabled(bool value) async {
    await _updateSetting('notificationsEnabled', value);
  }

  Future<void> updateLanguage(String value) async {
    await _updateSetting('language', value);
  }

  Future<void> updateTemperatureUnit(double value) async {
    await _updateSetting('temperatureUnit', value);
  }

  Future<void> updateAutoPowerManagement(bool value) async {
    await _updateSetting('autoPowerManagement', value);
  }

  Future<void> updateBatteryLowThreshold(double value) async {
    await _updateSetting('batteryLowThreshold', value);
  }

  Future<void> updateBatteryHighThreshold(double value) async {
    await _updateSetting('batteryHighThreshold', value);
  }

  Future<void> resetSettings() async {
    try {
      _setLoading(true);
      await _settingsRepository.resetSettings();
      _clearError();
    } catch (e) {
      _setError('Failed to reset settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> exportSettings() async {
    try {
      _setLoading(true);
      final exported = await _settingsRepository.exportSettings();
      _clearError();
      return exported;
    } catch (e) {
      _setError('Failed to export settings: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      _setLoading(true);
      await _settingsRepository.importSettings(settings);
      _clearError();
    } catch (e) {
      _setError('Failed to import settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    try {
      _setLoading(true);
      await _settingsRepository.updateSetting(key, value);
      _clearError();
    } catch (e) {
      _setError('Failed to update $key: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
