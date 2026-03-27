import 'dart:async';
import 'package:signals/signals.dart';

// =============================================================================
// STATE
// =============================================================================
final energyInWattHours = signal(0.95);
final isCharging = signal(true);
final batteryVoltage = signal(12.0);
final maxCapacity = signal(1.0);
final tierName = signal('Lead-Acid');
final chargeMultiplier = signal(1.0);
final efficiency = signal(0.85);

// =============================================================================
// INTERNAL
// =============================================================================
Timer? _dischargeTimer;

// =============================================================================
// ACTIONS
// =============================================================================
void updateBatteryRadiation(double radiationValue) {
  final chargeAmount = radiationValue * 0.01 * chargeMultiplier.value;
  if (energyInWattHours.value < maxCapacity.value) {
    energyInWattHours.value = (energyInWattHours.value + chargeAmount).clamp(
      0.0,
      maxCapacity.value,
    );
    isCharging.value = true;
  } else {
    isCharging.value = false;
  }
}

void stopBatteryCharging() {
  isCharging.value = false;
}

void dischargeBattery() {
  if (energyInWattHours.value > 0) {
    // Less efficient = more energy lost during discharge
    final dischargeAmount = 0.005 / efficiency.value;
    energyInWattHours.value = (energyInWattHours.value - dischargeAmount).clamp(
      0.0,
      maxCapacity.value,
    );
  }
}

void chargeBattery(double amperes) {
  if (energyInWattHours.value < maxCapacity.value) {
    final chargeAmount =
        amperes * 0.01 * chargeMultiplier.value * efficiency.value;
    energyInWattHours.value = (energyInWattHours.value + chargeAmount).clamp(
      0.0,
      maxCapacity.value,
    );
    isCharging.value = true;
  } else {
    isCharging.value = false;
  }
}

void applyBatteryUpgrade({
  required double newMaxCapacity,
  required double newVoltage,
  required String newTierName,
  required double newChargeMultiplier,
  required double newEfficiency,
}) {
  batch(() {
    maxCapacity.value = newMaxCapacity;
    batteryVoltage.value = newVoltage;
    tierName.value = newTierName;
    chargeMultiplier.value = newChargeMultiplier;
    efficiency.value = newEfficiency;
    // Clamp energy to new max capacity if needed
    energyInWattHours.value = energyInWattHours.value.clamp(
      0.0,
      newMaxCapacity,
    );
  });
}

void startBatteryDischarge() {
  _dischargeTimer?.cancel();
  _dischargeTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => dischargeBattery(),
  );
}

void disposeBattery() {
  _dischargeTimer?.cancel();
}
