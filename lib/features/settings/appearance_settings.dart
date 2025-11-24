import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'settings_provider.dart';
import 'settings_tile.dart';

class AppearanceSettingsProvider extends SettingsProvider {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  @override
  Future<void> loadSettings() async {
    await loadBaseSettings((settings) => _darkMode = settings.darkMode);
  }

  Future<void> updateDarkMode(bool value) async {
    await updateWithLoading(
      () => settingsRepository.updateDarkMode(value),
      'Failed to update dark mode',
    );
    _darkMode = value;
  }
}

class AppearanceSettingsView extends StatelessWidget {
  const AppearanceSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => AppearanceSettingsProvider(),
      builder: (_, provider) {
        return SwitchSettingsTile(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          subtitle: 'Toggle dark theme',
          value: provider.darkMode,
          onChanged: provider.updateDarkMode,
          isLoading: provider.isLoading,
          error: provider.error,
        );
      },
    );
  }
}
