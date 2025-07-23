import 'package:solar_system/_archive/domain/models/inverter.dart';
import 'package:solar_system/main.dart';

import '../../domain/apis/settings_repository.dart';

void _restoreApp() {
  print('restoreApp');

  /// 1. restore darkRepository
  // darkRepository.restore();

  /// 2. restore battery
  /// 3. restore flowRepository
  /// 4. restore inverter
  // inverterRepository.restore();

  /// 5. restore loadsRepository
  /// 6. restore panelsRepository
  /// 7. restore utilityRepository
}

void sellOutTheInverter() {
  inverter.status.set(InverterStatus.notAvailable);
}

class SettingsPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Settings'.text(),
        suffixes: [
          FHeaderAction.x(
            onPress: () => navigator.back(),
            // child: Icon(FIcons.arrowLeft),
          ),
        ],
      ),
      child: Column(
        children: [
          FButton(
            onPress: isRestored() ? null : _restoreApp,
            child: 'RESTORE APP'.text(),
          ).pad(),
          FButton(
            onPress: sellOutTheInverter,
            child: 'SELL OUT THE INVERTER'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
