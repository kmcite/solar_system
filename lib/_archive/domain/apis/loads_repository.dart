import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/_archive/domain/models/load.dart';
import 'package:solar_system/main.dart';

final loadsRepository = LoadsRepository();

class LoadsRepository extends ChangeNotifier {
  final loadsRM = mapSignal<int, Load>({});

  void put(Load load) {}

  void remove(int id) {}

  Iterable<Load> get loads {
    return loadsRM.values;
  }

  double get allLoads {
    return loadsRM.values.fold(
      0,
      (sum, load) {
        return sum + load.power;
      },
    );
  }

  double get activeLoad {
    return loadsRM.values.where((load) => load.status).fold(
      0,
      (sum, load) {
        if (load.status) {
          return sum + load.power;
        }
        return sum + load.power;
      },
    );
  }
}
