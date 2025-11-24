import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'settings_provider.dart';
import 'settings_tile.dart';

class SystemSettingsProvider extends SettingsProvider {
  double _batteryLowThreshold = 20.0;
  double _batteryHighThreshold = 80.0;

  double get batteryLowThreshold => _batteryLowThreshold;
  double get batteryHighThreshold => _batteryHighThreshold;

  @override
  Future<void> loadSettings() async {
    await loadBaseSettings((settings) {
      _batteryLowThreshold = settings.batteryLowThreshold;
      _batteryHighThreshold = settings.batteryHighThreshold;
    });
  }

  Future<void> updateBatteryLowThreshold(double value) async {
    await updateWithLoading(
      () => settingsRepository.updateBatteryLowThreshold(value),
      'Failed to update battery low threshold',
    );
    _batteryLowThreshold = value;
  }

  Future<void> updateBatteryHighThreshold(double value) async {
    await updateWithLoading(
      () => settingsRepository.updateBatteryHighThreshold(value),
      'Failed to update battery high threshold',
    );
    _batteryHighThreshold = value;
  }
}

class SystemSettingsView extends StatelessWidget {
  const SystemSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => SystemSettingsProvider(),
      builder: (_, provider) {
        return Card(
          child: Column(
            children: [
              SliderSettingsTile(
                icon: Icons.battery_alert,
                title: 'Battery Low Threshold',
                subtitle:
                    'Alert when battery falls below ${provider.batteryLowThreshold.round()}%',
                value: provider.batteryLowThreshold,
                min: 10.0,
                max: 50.0,
                divisions: 8,
                valueFormatter: (value) => '${value.round()}%',
                onChanged: provider.updateBatteryLowThreshold,
                isLoading: provider.isLoading,
                error: provider.error,
              ),
              const Divider(),
              SliderSettingsTile(
                icon: Icons.battery_full,
                title: 'Battery High Threshold',
                subtitle:
                    'Consider battery full at ${provider.batteryHighThreshold.round()}%',
                value: provider.batteryHighThreshold,
                min: 70.0,
                max: 100.0,
                divisions: 6,
                valueFormatter: (value) => '${value.round()}%',
                onChanged: provider.updateBatteryHighThreshold,
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
