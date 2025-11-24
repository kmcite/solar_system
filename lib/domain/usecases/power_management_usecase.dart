import '../entities/battery.dart';
import '../entities/inverter.dart';
import '../entities/solar_flow.dart';
import '../entities/panels.dart';
import '../entities/loads.dart';
import '../entities/utility.dart';
import '../entities/settings.dart';
import '../entities/changeover.dart';

/// Use case for managing power flow in the solar system
class PowerManagementUseCase {
  /// Calculate power balance and determine battery charging/discharging
  PowerBalance calculatePowerBalance({
    required Panels panels,
    required Loads loads,
    required Inverter inverter,
    required Battery battery,
  }) {
    final generation = panels.totalOutput;
    final consumption = loads.totalConsumption;
    final netPower = generation - consumption;

    return PowerBalance(
      generation: generation,
      consumption: consumption,
      netPower: netPower,
      batteryCurrent: netPower / battery.voltage,
      shouldChargeBattery: netPower > 0 && !battery.isFullyCharged,
      shouldDischargeBattery: netPower < 0 && !battery.isEmpty,
    );
  }

  /// Determine optimal changeover state based on system conditions
  ChangeoverState determineOptimalChangeoverState({
    required SolarFlow flow,
    required Inverter inverter,
    required Battery battery,
    required Utility utility,
    required AppSettings settings,
  }) {
    // If flow is not active, use utility
    if (!flow.isActive) {
      return ChangeoverState.utility;
    }

    // If inverter is not in solar mode, use utility
    if (!inverter.isSolarMode) {
      return ChangeoverState.utility;
    }

    // If battery is critically low, use utility if available
    if (battery.stateOfCharge < settings.batteryLowThreshold &&
        utility.isOnline) {
      return ChangeoverState.utility;
    }

    // If conditions are good, use solar
    return ChangeoverState.solar;
  }

  /// Check if power management should be active
  bool shouldManagePower({
    required SolarFlow flow,
    required Inverter inverter,
    required AppSettings settings,
  }) {
    return flow.isActive &&
        inverter.isSolarMode &&
        settings.autoPowerManagement;
  }

  /// Calculate battery state after power flow
  Battery calculateBatteryState(
    Battery currentBattery,
    PowerBalance powerBalance,
    Duration duration,
  ) {
    if (powerBalance.shouldChargeBattery) {
      final chargeAdded = powerBalance.batteryCurrent * duration.inSeconds;
      final newCharge = (currentBattery.charge + chargeAdded).clamp(
        0.0,
        currentBattery.capacity,
      );

      return currentBattery.copyWith(charge: newCharge);
    } else if (powerBalance.shouldDischargeBattery) {
      final chargeRemoved = (powerBalance.batteryCurrent * duration.inSeconds)
          .abs();
      final newCharge = (currentBattery.charge - chargeRemoved).clamp(
        0.0,
        currentBattery.capacity,
      );

      return currentBattery.copyWith(charge: newCharge);
    }

    return currentBattery;
  }
}

/// Power balance calculation result
class PowerBalance {
  final double generation;
  final double consumption;
  final double netPower;
  final double batteryCurrent;
  final bool shouldChargeBattery;
  final bool shouldDischargeBattery;

  const PowerBalance({
    required this.generation,
    required this.consumption,
    required this.netPower,
    required this.batteryCurrent,
    required this.shouldChargeBattery,
    required this.shouldDischargeBattery,
  });

  @override
  String toString() {
    return 'PowerBalance(gen: ${generation.toStringAsFixed(1)}W, '
        'cons: ${consumption.toStringAsFixed(1)}W, '
        'net: ${netPower.toStringAsFixed(1)}W, '
        'battery: ${batteryCurrent.toStringAsFixed(2)}A)';
  }
}
