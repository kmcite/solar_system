import '../../main.dart';

final inverterRepository = Inverter();

class InverterState {
  InverterStatus status = InverterStatus.off;
  InverterOperation operation = InverterOperation.manual;
}

class Inverter extends ChangeNotifier {
  InverterState? inverterState = InverterState();

  bool get isInverterPresent => inverterState != null;

  void buyInverter() {
    inverterState = InverterState();
    notifyListeners();
  }

  bool get isOff => status == InverterStatus.off;

  InverterOperation get operation {
    return inverterState?.operation ?? InverterOperation.manual;
  }

  InverterStatus get status {
    return inverterState?.status ?? InverterStatus.off;
  }

  void setOperation(InverterOperation operation) {
    inverterState?.operation = operation;
    notifyListeners();
  }

  void setStatus(InverterStatus status) {
    inverterState?.status = status;
    notifyListeners();
  }

  void restore() {
    inverterState = null;
    notifyListeners();
  }
}

enum InverterStatus {
  battery,
  solar,
  utility,
  off;

  IconData get icon {
    return switch (this) {
      InverterStatus.battery => Icons.battery_full,
      InverterStatus.solar => Icons.wb_sunny,
      InverterStatus.utility => Icons.electric_bolt,
      InverterStatus.off => Icons.power_off,
    };
  }

  // double get powerUsage => switch (this) {
  //       InverterStatus.off => 0,
  //       InverterStatus.solar => loadsRepository.totalLoad,
  //       InverterStatus.battery => loadsRepository.totalLoad,
  //       InverterStatus.utility => loadsRepository.totalLoad,
  //     };
}

enum InverterOperation {
  auto,
  manual;
}
