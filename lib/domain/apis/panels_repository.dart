import 'package:solar_system/domain/models/panel.dart';
import 'package:solar_system/main.dart';

final panelsRepository = PanelsRepository();

class PanelsRepository extends ChangeNotifier {
  final _panels = <int, Panel>{
    0: Panel(),
  };

  void remove(int panelId) {
    _panels.remove(panelId);
    notifyListeners();
  }

  bool contains(int panelId) => _panels.containsKey(panelId);

  int get powerCapacity {
    return _panels.values.fold(
      0,
      (value, panel) {
        return value + panel.powerCapacity;
      },
    );
  }

  void put(Panel panel) {
    _panels[panel.id] = panel;
    notifyListeners();
  }

  Iterable<Panel> get panels => _panels.values;
}
