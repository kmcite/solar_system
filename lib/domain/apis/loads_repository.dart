import 'package:solar_system/domain/models/load.dart';
import 'package:solar_system/main.dart';

final loadsRepository = LoadsRepository();

class LoadsRepository extends ChangeNotifier {
  Map<int, Load> _loads = {};
  void put(Load load) {
    _loads[load.id] = load;
    notifyListeners();
  }

  void remove(int id) {
    _loads.remove(id);
    notifyListeners();
  }

  Iterable<Load> get loads {
    return _loads.values;
  }

  double get totalLoad {
    return _loads.values.fold(
      0,
      (sum, load) {
        return sum + load.powerUsage;
      },
    );
  }
}
