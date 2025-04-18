import '../../main.dart';
import '../apis/loads_repository.dart';

final inverter = Inverter();

class Inverter extends ChangeNotifier {
  InverterStatus status = InverterStatus.off;
  bool get isOff => status == InverterStatus.off;
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

  double get powerUsage => switch (this) {
        InverterStatus.off => 0,
        InverterStatus.solar => loadsRepository.totalLoad,
        InverterStatus.battery => loadsRepository.totalLoad,
        InverterStatus.utility => loadsRepository.totalLoad,
      };
}
