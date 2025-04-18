import 'package:solar_system/main.dart';

final darkRepository = DarkRepository();

class DarkRepository extends ChangeNotifier {
  bool dark = true;
  void toggle() {
    dark = !dark;
    notifyListeners();
  }
}
