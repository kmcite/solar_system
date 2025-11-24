import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'settings_provider.dart';
import 'settings_tile.dart';

class RegionalSettingsProvider extends SettingsProvider {
  String _language = 'en';
  double _temperatureUnit = 0.0;

  String get language => _language;
  double get temperatureUnit => _temperatureUnit;
  String get temperatureUnitDisplay => _temperatureUnit == 0.0 ? '°C' : '°F';

  @override
  Future<void> loadSettings() async {
    await loadBaseSettings((settings) {
      _language = settings.language;
      _temperatureUnit = settings.temperatureUnit;
    });
  }

  Future<void> updateLanguage(String value) async {
    await updateWithLoading(
      () => settingsRepository.updateLanguage(value),
      'Failed to update language',
    );
    _language = value;
  }

  Future<void> updateTemperatureUnit(double value) async {
    await updateWithLoading(
      () => settingsRepository.updateTemperatureUnit(value),
      'Failed to update temperature unit',
    );
    _temperatureUnit = value;
  }
}

class RegionalSettingsView extends StatelessWidget {
  const RegionalSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => RegionalSettingsProvider(),
      builder: (_, provider) {
        return Card(
          child: Column(
            children: [
              DropdownSettingsTile<String>(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Select app language',
                value: provider.language,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'es', child: Text('Español')),
                  DropdownMenuItem(value: 'fr', child: Text('Français')),
                  DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    provider.updateLanguage(value);
                  }
                },
                isLoading: provider.isLoading,
                error: provider.error,
              ),
              const Divider(),
              DropdownSettingsTile<double>(
                icon: Icons.thermostat,
                title: 'Temperature Unit',
                subtitle:
                    'Unit for temperature display (${provider.temperatureUnitDisplay})',
                value: provider.temperatureUnit,
                items: const [
                  DropdownMenuItem(value: 0.0, child: Text('Celsius (°C)')),
                  DropdownMenuItem(value: 1.0, child: Text('Fahrenheit (°F)')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    provider.updateTemperatureUnit(value);
                  }
                },
                isLoading: provider.isLoading,
                error: provider.error,
              ),
            ],
          ),
        );
      },
    );
  }
}
