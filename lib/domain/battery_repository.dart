import 'package:solar_system/main.dart';

class Battery {
  /// Current stored energy in the battery, measured in **watt-seconds (Ws)**.
  /// - Increases when charging, decreases when discharging.
  /// - Always clamped between `0` and [capacity].
  double charge = 0.0;

  /// Nominal **voltage** of the battery in **volts (V)**.
  /// - Assumed constant for simplicity.
  /// - Used for converting between stored energy (Ws) and current (A).
  double voltage = 48.0;

  /// Maximum allowed **charging current** in **amperes (A)**.
  /// - Defines the safe upper limit of charging rate.
  /// - Useful for capping incoming current from inverter/panels.
  double maximumChargingCurrent = 60.0;

  /// Maximum **energy capacity** of the battery in **watt-seconds (Ws)**.
  /// - Equivalent to `1 kWh = 3,600,000 Ws`.
  /// - Represents a fully charged battery.
  double capacity = 3_600_000.0;

  /// **State of Charge (SOC)**: fraction of stored energy compared to [capacity].
  /// - Ranges between `0.0` (empty) and `1.0` (full).
  double get soc => charge / capacity;

  /// Approximate **ampere-hours equivalent** (A·h), derived as:
  ///   `charge / voltage`.
  /// - Useful when converting energy into a current representation.
  double get power => charge / voltage;
}

class BatteryRepository extends Repository<Battery> {
  BatteryRepository() : super(Battery());

  /// Sets the stored [charge] in watt-seconds.
  /// - Clamps the value between `0` and [capacity].
  /// - Calls [notify] so listeners can react to state changes.
  void setCharge(double chargingPower) {
    emit(state..charge = chargingPower.clamp(0, state.capacity));
  }
}
