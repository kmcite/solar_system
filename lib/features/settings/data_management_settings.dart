import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../../utils/router.dart';
import 'settings_provider.dart';
import 'settings_tile.dart';

class DataManagementSettingsProvider extends SettingsProvider {
  @override
  Future<void> loadSettings() async {
    // No settings to load for data management
    await loadBaseSettings((_) {});
  }

  Future<Map<String, dynamic>> exportSettings() async {
    Map<String, dynamic> exported = {};
    await updateWithLoading(
      () async {
        exported = await settingsRepository.exportSettings();
      },
      'Failed to export settings',
    );
    return exported;
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    await updateWithLoading(
      () => settingsRepository.importSettings(settings),
      'Failed to import settings',
    );
  }

  Future<void> resetSettings() async {
    await updateWithLoading(
      () => settingsRepository.resetSettings(),
      'Failed to reset settings',
    );
  }
}

class DataManagementSettingsView extends StatelessWidget {
  const DataManagementSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => DataManagementSettingsProvider(),
      builder: (_, provider) {
        return Card(
          child: Column(
            children: [
              SettingsTile(
                icon: Icons.upload_file,
                title: 'Export Settings',
                subtitle: 'Export current settings to file',
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _exportSettings(context, provider),
                isLoading: provider.isLoading,
                error: provider.error,
              ),
              const Divider(),
              SettingsTile(
                icon: Icons.download,
                title: 'Import Settings',
                subtitle: 'Import settings from file',
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _importSettings(context, provider),
                isLoading: provider.isLoading,
                error: provider.error,
              ),
              const Divider(),
              SettingsTile(
                icon: Icons.restore,
                title: 'Reset to Defaults',
                subtitle: 'Reset all settings to default values',
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showResetDialog(context, provider),
                isLoading: provider.isLoading,
                error: provider.error,
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportSettings(
    BuildContext context,
    DataManagementSettingsProvider provider,
  ) {
    provider
        .exportSettings()
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings exported successfully'),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to export settings'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  void _importSettings(
    BuildContext context,
    DataManagementSettingsProvider provider,
  ) {
    provider
        .importSettings({})
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings imported successfully'),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to import settings'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  void _showResetDialog(
    BuildContext context,
    DataManagementSettingsProvider provider,
  ) {
    context.toDialog(
      AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider
                  .resetSettings()
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings reset to defaults'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  })
                  .catchError((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to reset settings'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
