import 'package:manager/dark/dark_repository.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/main.dart';

import '../../domain/apis/settings_repository.dart';

bool get _isRestored => settingsRepository.isRestored;

void _restoreApp() {
  print('restoreApp');

  /// 1. restore darkRepository
  darkRepository.restore();

  /// 2. restore battery
  /// 3. restore flowRepository
  /// 4. restore inverter
  inverterRepository.restore();

  /// 5. restore loadsRepository
  /// 6. restore panelsRepository
  /// 7. restore utilityRepository
}

class SettingsPage extends GUI {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Settings'.text(),
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: _isRestored ? null : _restoreApp,
            child: 'RESTORE APP'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
