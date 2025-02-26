import 'package:manager/manager.dart';

class Panels {
  bool status = false;
  int currentPower = 100;

  Map<String, dynamic> toJson() {
    return {"status": status, "currentPower": currentPower};
  }

  Panels.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    currentPower = json['currentPower'] ?? 100;
  }
  Panels();
}

/// PanelsBloc refactored
class PanelsBloc {
  final panelsRM = RM.inject(() => Panels());

  Panels get panels => panelsRM.state;
  bool get status => panels.status;
  int get currentPower => panels.currentPower;

  set panels(Panels value) =>
      panelsRM
        ..state = value
        ..notify();

  void toggle() => panels = panels..status = !status;
  void increasePower(int amount) =>
      panels = panels..currentPower += amount;
}

final panelsBloc = PanelsBloc();
