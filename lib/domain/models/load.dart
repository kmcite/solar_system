// import 'package:objectbox/objectbox.dart';

abstract class Load {
  PowerBehavoir get power;
  int id = 0;
  String name = 'Unknown';
}

abstract class PowerBehavoir {
  double get powerUsage;
}

class ValuePowerBehavior extends PowerBehavoir {
  final double value;
  ValuePowerBehavior(this.value);
  double get powerUsage => 10;
}

class NoPowerBehavoir extends PowerBehavoir {
  double get powerUsage => 0;
}

class Fan extends Load {
  @override
  PowerBehavoir get power => ValuePowerBehavior(40);
  @override
  int get id => 1;
  double get powerUsage => power.powerUsage;
  @override
  String get name => 'Fan';
}

class Bulb extends Load {
  @override
  int get id => 2;
  @override
  PowerBehavoir get power => NoPowerBehavoir();
  double get powerUsage => power.powerUsage;
  @override
  String get name => 'Bulb';
}

class Iron extends Load {
  @override
  int get id => 3;
  PowerBehavoir get power => ValuePowerBehavior(650);
  double get powerUsage => power.powerUsage;
  @override
  String get name => 'Iron';
}
