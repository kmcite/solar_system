import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/settings_repository_impl.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = context.watch<SettingsRepositoryImpl>();
    final isDarkMode = settingsRepo.dark;

    return IconButton(
      onPressed: () => settingsRepo.toggleDark(),
      icon: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}
