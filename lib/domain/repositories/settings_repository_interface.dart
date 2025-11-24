import '../entities/settings.dart';

/// Repository interface for settings data access
abstract class SettingsRepositoryInterface {
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
