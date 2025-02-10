import 'package:manager/manager.dart';

/// InverterBloc refactored
final InverterBloc inverterBloc = InverterBloc();

class InverterBloc {
  int inverterEnergyUsage = 2;

  final inverterRM = RM.inject(
    () => Inverter(),
    persist: () => PersistState(
      key: 'inverter',
      toJson: (s) => jsonEncode(s.toJson()),
      fromJson: (json) => Inverter.fromJson(jsonDecode(json)),
    ),
  );

  set inverter(Inverter value) => inverterRM
    ..state = value
    ..notify();

  Inverter get inverter => inverterRM.state;
  bool get status => inverter.status;

  void toggle() => inverter = inverter..status = !inverter.status;
}

class Inverter {
  bool status = false;
  Map<String, dynamic> toJson() {
    return {
      "status": status,
    };
  }

  Inverter.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
  }
  Inverter();
}
