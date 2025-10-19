import 'package:solar_system/main.dart';

class Inverter {
  bool isRunning = false;
  double maxPower = 5000.0; // in Watts
  // double maxSupportedLoad = 6000;
  InverterMode mode = InverterMode.solar;
  Voltage voltage = Voltage.eu; // in Volts
  double get current => power / voltage.value; // in Amps
  double get power => isRunning ? maxPower : 0.0;
}

/// -> repository
class InverterRepository extends Repository<Inverter> {
  InverterRepository() : super(Inverter());

  double effectivePower(double solarPower) {
    return solarPower > value.maxPower ? value.maxPower : solarPower;
  }

  void togglePower() {
    emit(value..isRunning = !value.isRunning);
  }

  bool get isSolarMode => value.mode == InverterMode.solar;
  bool get isUtilityMode => value.mode == InverterMode.utility;
  bool get isBatteryMode => value.mode == InverterMode.battery;

  void sellout() {
    emit(value..isRunning = false);
  }

  void buy() {
    emit(value..isRunning = true);
  }

  void setMode(InverterMode mode) {
    emit(value..mode = mode);
  }

  void setVoltage(Voltage voltage) {
    emit(value..voltage = voltage);
  }
}

enum InverterMode {
  battery,
  solar,
  utility;

  IconData get icon {
    return switch (this) {
      InverterMode.battery => FIcons.battery,
      InverterMode.solar => Icons.solar_power,
      InverterMode.utility => FIcons.utilityPole,
    };
  }

  Color get color {
    return switch (this) {
      InverterMode.battery => Colors.red,
      InverterMode.solar => Colors.yellow,
      InverterMode.utility => Colors.blue,
    };
  }
}

enum Voltage {
  us,
  eu;

  double get value => switch (this) {
    Voltage.us => 120,
    Voltage.eu => 230,
  };
  IconData get icon => switch (this) {
    Voltage.us => FIcons.dollarSign,
    Voltage.eu => Icons.euro,
  };

  Color get color => switch (this) {
    Voltage.us => Colors.red,
    Voltage.eu => Colors.yellow,
  };
}
