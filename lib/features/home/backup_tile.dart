import 'package:solar_system/domain/models/battery.dart';
import 'package:solar_system/domain/models/inverter.dart';
import 'package:solar_system/features/home/battery_charge.dart';
import 'package:solar_system/main.dart';

extension on BackupTile {
  double get current => inverter.status.powerUsage / battery.voltage;

  double get voltage => battery.voltage;
  double get capacity => battery.capacity;
}

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
          Row(
            children: [
              Text('Battery: '),
              Badge(
                label: battery.remainingCapacity
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
                label: voltage.toStringAsFixed(2).text(),
                backgroundColor: Colors.green,
              ),
              Text(' V'),
            ],
          ),
          Row(
            children: [
              Text('Current: '),
              Badge(
                label: current.toStringAsFixed(2).text(),
                backgroundColor: Colors.red,
              ),
              Text(' A'),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
      trailing: batteryByRemainingCapacity(capacity),
    );
  }
}
