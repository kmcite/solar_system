import 'dart:async';
import 'package:flutter/foundation.dart';

enum BatteryChemistry {
  wet_lead_acid,
  gel_lead_acid,
  graphene_lead_acid,
  nano_carbon_fiber_lead_acid,
  lithium_iron_phosphate,
  lithium_nickel_manganese_cobalt_oxide,
  lithium_ion_polymer,
  lithium_titanate_oxide;

  double get voltage => switch (this) {
    .wet_lead_acid => 2.1,
    .gel_lead_acid => 2.1,
    .graphene_lead_acid => 2.1,
    .nano_carbon_fiber_lead_acid => 2.1,
    .lithium_iron_phosphate => 3.2,
    .lithium_nickel_manganese_cobalt_oxide => 3.6,
    .lithium_ion_polymer => 3.7,
    .lithium_titanate_oxide => 2.4,
  };

  int get cycles => switch (this) {
    .wet_lead_acid => 300,
    .gel_lead_acid => 300,
    .graphene_lead_acid => 900,
    .nano_carbon_fiber_lead_acid => 1000,
    .lithium_iron_phosphate => 8000,
    .lithium_nickel_manganese_cobalt_oxide => 3000,
    .lithium_ion_polymer => 1500,
    .lithium_titanate_oxide => 20000,
  };
}

final charger = ChargerNotifier();

class ChargerNotifier extends ChangeNotifier {
  double amperes = 10.0;
  num chargeWithPower(num voltage) {
    lifetime = lifetime - .001;
    return amperes * voltage;
  }

  double lifetime = 1;
}

final battery = BatteryNotifier();

class BatteryNotifier extends ChangeNotifier {
  BatteryNotifier() {
    startBatteryDischarge(); // starts from the app startup
  }
  BatteryChemistry chemistry = .wet_lead_acid;
  num energy = 1; // kWhr - BTU
  bool isCharging = false;
  num get voltage => chemistry.voltage;

  late int currentRemainingCycles = totalCycles;

  int get totalCycles => chemistry.cycles;

  num maximumCapacity = 1;
  num chargeMultiplier = 1;

  //// ACTIONS
  void charge(num power) {
    isCharging = true;
    energy = (energy + power * 0.01).clamp(0, 1);
    notifyListeners();
  }

  Timer? _dischargeTimer;

  // =============================================================================
  // ACTIONS
  // =============================================================================
  void updateBatteryRadiation(double radiationValue) {
    final chargeAmount = radiationValue * 0.01 * chargeMultiplier;
    if (energy < maximumCapacity) {
      energy = (energy + chargeAmount).clamp(
        0.0,
        maximumCapacity,
      );
      isCharging = true;
    } else {
      isCharging = false;
    }
  }

  void stopBatteryCharging() {
    isCharging = false;
  }

  void dischargeBattery() {
    if (energy > 0) {
      // Less efficient = more energy lost during discharge
      final dischargeAmount = 0.005 / totalCycles;
      energy = (energy - dischargeAmount).clamp(
        0.0,
        maximumCapacity,
      );
    }
  }

  void chargeBattery(double amperes) {
    if (energy < maximumCapacity) {
      final chargeAmount = amperes * 0.01 * chargeMultiplier * totalCycles;
      energy = (energy + chargeAmount).clamp(
        0.0,
        maximumCapacity,
      );
      isCharging = true;
    } else {
      isCharging = false;
    }
  }

  /// OUTSIDE COMMUNICATION
  void applyBatteryUpgrade({
    required double newMaxCapacity,
    required double newVoltage,
    required String newTierName,
    required double newChargeMultiplier,
    required double newEfficiency,
  }) {
    maximumCapacity = newMaxCapacity;
    // batteryVoltage = newVoltage;
    // tierName = newTierName; // Changed from tierName.value = newTierName;
    chargeMultiplier = newChargeMultiplier;
    // totalCycles = newEfficiency;
    // Clamp energy to new max capacity if needed
    energy = energy.clamp(
      0.0,
      newMaxCapacity,
    );
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
}
