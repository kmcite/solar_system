import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'settings_provider.dart';
import 'settings_tile.dart';

class NotificationSettingsProvider extends SettingsProvider {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  @override
  Future<void> loadSettings() async {
    await loadBaseSettings(
      (settings) => _notificationsEnabled = settings.notificationsEnabled,
    );
  }

  Future<void> updateNotificationsEnabled(bool value) async {
    await updateWithLoading(
      () => settingsRepository.updateNotificationsEnabled(value),
      'Failed to update notifications',
    );
    _notificationsEnabled = value;
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => NotificationSettingsProvider(),
      builder: (_, provider) {
        return SwitchSettingsTile(
          icon: Icons.notifications,
          title: 'Enable Notifications',
          subtitle: 'Receive system alerts and updates',
          value: provider.notificationsEnabled,
          onChanged: provider.updateNotificationsEnabled,
          isLoading: provider.isLoading,
          error: provider.error,
        );
      },
    );
  }
}
