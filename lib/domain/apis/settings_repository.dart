import 'package:solar_system/main.dart';

final settingsRepository = SettingsRepository();

class SettingsRepository extends ChangeNotifier {
  bool _isRestored = true;
  bool get isRestored => _isRestored;
  set isRestored(bool value) {
    _isRestored = value;
    notifyListeners();
  }
}
