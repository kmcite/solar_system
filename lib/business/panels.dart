import 'package:flutter/foundation.dart';
import 'package:solar_system/domain/models/models.dart';

final panels = PanelsNotifier();

class PanelsNotifier extends ChangeNotifier {
  List<PanelModel> panels = [];
  double panelRadiation = 0.0;
  double get ratedMaxCapacity => panels.fold(
    0.0,
    (total, panel) => total + panel.ratedMaxPowerOutput,
  );
  double get currentMaxCapacity => panels.fold(
    0.0,
    (total, panel) => total + panel.currentMaxPowerOutput,
  );
  double get currentPowerOutput => panels
      .where((panel) => panel.status)
      .fold(
        0.0,
        (total, panel) => total + panel.currentPowerOutput(panelRadiation),
      );
  int _nextPanelId = 1;

  void createPanel() {
    panels = [...panels, PanelModel(id: _nextPanelId++)];
    notifyListeners();
  }

  void putPanel(PanelModel panel) {
    panels = panels.map((p) => p.id == panel.id ? panel : p).toList();
    notifyListeners();
  }

  void togglePanelActivation(PanelModel panel) {
    panels = panels.map((p) {
      return p.id == panel.id ? p.copyWith(status: !p.status) : p;
    }).toList();
    notifyListeners();
  }

  void removePanel(int id) {
    panels = panels.where((p) => p.id != id).toList();
    notifyListeners();
  }

  void removeAllPanels() {
    panels = [];
    notifyListeners();
  }

  void setPanelRadiation(double value) {
    panelRadiation = value;
    notifyListeners();
  }

  PanelModel getPanel(int index) => panels[index];
}
