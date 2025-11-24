import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/settings.dart';
import 'package:solar_system/domain/repositories/settings_repository.dart';

class DarkModeToggleProvider extends ChangeNotifier {
  late final ISettingsRepository _settingsRepository =
      find<ISettingsRepository>();
  StreamSubscription<AppSettings>? _subscription;

  AppSettings _settings = AppSettings(id: 'app_settings');

  DarkModeToggleProvider() {
    _subscription = _settingsRepository.watch().listen((settings) {
      _settings = settings;
      notifyListeners();
    });
  }

  bool get isDarkMode => _settings.darkMode;

  void toggleDark() {
    _settingsRepository.updateDarkMode(!_settings.darkMode);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => DarkModeToggleProvider(),
      builder: (_, provider) {
        final isDarkMode = provider.isDarkMode;

        return IconButton(
          onPressed: () => provider.toggleDark(),
          icon: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
