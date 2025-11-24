import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Base provider for all settings features with common functionality
abstract class SettingsProvider extends ChangeNotifier {
  late final ISettingsRepository settingsRepository;
  bool _isLoading = false;
  String? _error;

  SettingsProvider() {
    settingsRepository = find<ISettingsRepository>();
    loadSettings();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Template method for subclasses to implement their specific loading logic
  Future<void> loadSettings();

  /// Common settings loading method
  Future<void> loadBaseSettings(
    void Function(AppSettings) updateLocalState,
  ) async {
    try {
      setLoading(true);
      final settings = await settingsRepository.getSettings();
      updateLocalState(settings);
      clearError();
    } catch (e) {
      setError('Failed to load settings: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Common update method with loading and error handling
  Future<void> updateWithLoading(
    Future<void> Function() updateFunction,
    String errorMessage,
  ) async {
    try {
      setLoading(true);
      await updateFunction();
      clearError();
    } catch (e) {
      setError('$errorMessage: $e');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
