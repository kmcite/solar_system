import 'package:signals/signals.dart';

// =============================================================================
// STATE
// =============================================================================
final inverterStatus = signal(false);
final inverterOutputPower = signal(0.0);
final inverterVoltage = signal(0.0);
final inverterCurrent = signal(0.0);
final inverterUtilityVoltage = signal(0.0);
final inverterUtilityCurrent = signal(0.0);
final inverterPower = signal(0.0);

// =============================================================================
// ACTIONS
// =============================================================================
void toggleInverter() {
  inverterStatus.value = !inverterStatus.value;
}

void turnInverterOn() {
  inverterStatus.value = true;
}

void turnInverterOff() {
  inverterStatus.value = false;
}
