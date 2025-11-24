import 'package:flutter/material.dart';
import 'package:solar_system/utils/router.dart';
import 'appearance_settings.dart';
import 'notification_settings.dart';
import 'regional_settings.dart';
import 'system_settings.dart';
import 'data_management_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          onPressed: () => context.goToDashboard(),
          icon: const Icon(Icons.dashboard),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            AppearanceSettingsView(),
            SizedBox(height: 16),

            // Notifications Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            NotificationSettingsView(),
            SizedBox(height: 16),

            // Regional Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Regional',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            RegionalSettingsView(),
            SizedBox(height: 16),

            // System Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'System',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SystemSettingsView(),
            SizedBox(height: 16),

            // Data Management Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Data Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            DataManagementSettingsView(),
          ],
        ),
      ),
    );
  }
}
