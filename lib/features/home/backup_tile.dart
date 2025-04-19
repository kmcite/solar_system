import 'package:solar_system/domain/apis/loads_repository.dart';
import 'package:solar_system/domain/apis/panels_repository.dart';
import 'package:solar_system/domain/models/battery.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/features/home/battery_charge.dart';
import 'package:solar_system/main.dart';

double _powerUsage(InverterStatus status) {
  return switch (status) {
    InverterStatus.battery =>
      loadsRepository.totalLoad - batteryRepository.netPower,
    InverterStatus.solar =>
      loadsRepository.totalLoad - panelsRepository.powerCapacity,
    InverterStatus.utility => loadsRepository.totalLoad,
    InverterStatus.off => 0,
  };
}

double get _current {
  return _powerUsage(inverterRepository.status) /
      batteryRepository.voltage;
}

double get _voltage => batteryRepository.voltage;
double get _capacity => batteryRepository.capacity;

class BackupTile extends GUI {
  const BackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'BACKUP SYSTEM',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Manage your backup batteries'),
          Text('${batteryRepository.state}'),
          Row(
            children: [
              Text('Battery: '),
              Badge(
                label: batteryRepository.remainingCapacity
                    .toStringAsFixed(2)
                    .text(),
                backgroundColor: Colors.yellow,
              ),
              Text(' Ah'),
            ],
          ),
          Row(
            children: [
              Text('Voltage: '),
              Badge(
                label: _voltage.toStringAsFixed(2).text(),
                backgroundColor: Colors.green,
              ),
              Text(' V'),
            ],
          ),
          Row(
            children: [
              Text('Current: '),
              Badge(
                label: _current.toStringAsFixed(2).text(),
                backgroundColor: Colors.red,
              ),
              Text(' A'),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
      trailing: batteryByRemainingCapacity(_capacity),
    );
  }
}
