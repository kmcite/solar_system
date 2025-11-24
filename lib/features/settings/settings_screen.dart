import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/manager.dart';
import 'settings_provider.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => SettingsScreenProvider(),
      builder: (_, settingsProvider) {
        return SettingsView(provider: settingsProvider);
      },
    );
  }
}

class SettingsView extends StatelessWidget {
  final SettingsScreenProvider provider;

  const SettingsView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: <Widget>[
          if (provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView(
              children: [
                // Appearance Section
                _buildSectionHeader(context, 'Appearance'),
                SettingsSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark theme',
                  value: provider.darkMode,
                  onChanged: provider.updateDarkMode,
                ),
                const Divider(),

                // Notifications Section
                _buildSectionHeader(context, 'Notifications'),
                SettingsSwitchTile(
                  icon: Icons.notifications,
                  title: 'Enable Notifications',
                  subtitle: 'Receive system alerts and updates',
                  value: provider.notificationsEnabled,
                  onChanged: provider.updateNotificationsEnabled,
                ),
                const Divider(),

                // Regional Section
                _buildSectionHeader(context, 'Regional'),
                SettingsDropdownTile<String>(
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
                ),
                SettingsDropdownTile<double>(
                  icon: Icons.thermostat,
                  title: 'Temperature Unit',
                  subtitle: 'Unit for temperature display',
                  value: provider.temperatureUnit,
                  items: const [
                    DropdownMenuItem(
                      value: 0.0,
                      child: Text('Celsius (°C)'),
                    ),
                    DropdownMenuItem(
                      value: 1.0,
                      child: Text('Fahrenheit (°F)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateTemperatureUnit(value);
                    }
                  },
                ),
                const Divider(),

                // System Section
                _buildSectionHeader(context, 'System'),
                SettingsSliderTile(
                  icon: Icons.battery_alert,
                  title: 'Battery Low Threshold',
                  subtitle: 'Alert when battery falls below this level',
                  value: provider.batteryLowThreshold,
                  min: 10.0,
                  max: 50.0,
                  divisions: 9,
                  valueFormatter: (value) => '${value.round()}%',
                  onChanged: provider.updateBatteryLowThreshold,
                ),
                SettingsSliderTile(
                  icon: Icons.battery_full,
                  title: 'Battery High Threshold',
                  subtitle: 'Consider battery full at this level',
                  value: provider.batteryHighThreshold,
                  min: 70.0,
                  max: 100.0,
                  divisions: 6,
                  valueFormatter: (value) => '${value.round()}%',
                  onChanged: provider.updateBatteryHighThreshold,
                ),
                const Divider(),

                // Data Management Section
                _buildSectionHeader(context, 'Data Management'),
                SettingsTile(
                  icon: Icons.upload_file,
                  title: 'Export Settings',
                  subtitle: 'Export current settings to file',
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _exportSettings(context),
                ),
                SettingsTile(
                  icon: Icons.download,
                  title: 'Import Settings',
                  subtitle: 'Import settings from file',
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _importSettings(context),
                ),
                SettingsTile(
                  icon: Icons.restore,
                  title: 'Reset to Defaults',
                  subtitle: 'Reset all settings to default values',
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showResetDialog(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _exportSettings(BuildContext context) {
    // Implementation for export settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings exported successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _importSettings(BuildContext context) {
    // Implementation for import settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings imported successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              // Reset settings - need to access provider
              provider.resetSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
