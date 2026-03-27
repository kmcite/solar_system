import 'package:signals/signals.dart';
import '../domain/models/models.dart';

// =============================================================================
// STATE
// =============================================================================
final panels = signal<List<PanelModel>>([]);
final panelRadiation = signal(
  0.0,
); // fed from radiation signal via effect in main

// =============================================================================
// COMPUTED
// =============================================================================
final ratedMaxCapacity = computed(() {
  return panels.value.fold(
    0.0,
    (total, panel) => total + panel.ratedMaxPowerOutput,
  );
});

final currentMaxCapacity = computed(() {
  return panels.value.fold(
    0.0,
    (total, panel) => total + panel.currentMaxPowerOutput,
  );
});

final currentPowerOutput = computed(() {
  return panels.value
      .where((panel) => panel.status)
      .fold(
        0.0,
        (total, panel) =>
            total + panel.currentPowerOutput(panelRadiation.value),
      );
});

// =============================================================================
// INTERNAL
// =============================================================================
int _nextPanelId = 1;

// =============================================================================
// ACTIONS
// =============================================================================
void createPanel() {
  panels.value = [...panels.value, PanelModel(id: _nextPanelId++)];
}

void putPanel(PanelModel panel) {
  panels.value = panels.value.map((p) => p.id == panel.id ? panel : p).toList();
}

void togglePanelActivation(PanelModel panel) {
  panels.value = panels.value.map((p) {
    return p.id == panel.id ? p.copyWith(status: !p.status) : p;
  }).toList();
}

void removePanel(int id) {
  panels.value = panels.value.where((p) => p.id != id).toList();
}

void removeAllPanels() {
  panels.value = [];
}

void setPanelRadiation(double value) {
  panelRadiation.value = value;
}

PanelModel getPanel(int index) => panels.value[index];
