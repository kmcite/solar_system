import 'dart:async';

import 'package:solar_system/_archive/domain/models/panel.dart';
import 'package:solar_system/main.dart';

final panelsRepository = PanelsRepository();

class PanelsRepository extends ChangeNotifier {
  Timer? _timer;
  PanelsRepository() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        for (var panel in panels) {
          panel.power = panel.power - 0.1;
          put(panel);
        }
        notifyListeners();
      },
    );
  }
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Map<int, Panel> _panels = {};
  bool contains(int panelId) => _panels.containsKey(panelId);

  double get power {
    return panels.fold(
      0,
      (value, panel) {
        return value + panel.power;
      },
    );
  }

  void put(Panel panel) {
    _panels[panel.id] = panel;
    notifyListeners();
  }

  void remove(int id) {
    _panels.remove(id);
    notifyListeners();
  }

  Iterable<Panel> get panels {
    return _panels.values;
  }
}
