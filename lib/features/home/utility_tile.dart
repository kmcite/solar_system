import 'package:solar_system/domain/apis/loads_repository.dart';
import 'package:solar_system/domain/apis/utility_repository.dart';
import 'package:solar_system/main.dart';

mixin UtilityBloc {
  bool get utilityStatus => utilityRepository.status;
  int get voltage => utilityRepository.voltage;
  late final toggleUtility = utilityRepository.toggle;
  double get powerUsed => loadsRepository.totalLoad;
  int get current {
    return utilityStatus ? loadsRepository.totalLoad ~/ voltage : 0;
  }
}

class UtilityTile extends GUI with UtilityBloc {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'UTILITY',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Voltage from Utility: '),
              Badge(
                label: voltage.text(),
                backgroundColor: Colors.green,
              ),
              Text(' V'),
            ],
          ),
          Row(
            children: [
              Text('Current drawn: '),
              Badge(
                label: current.text(),
                backgroundColor: Colors.red,
              ),
              Text(' A'),
            ],
          ),
          'Power used here: $powerUsed W'.text(),
        ],
      ),
      trailing: IconButton(
        onPressed: toggleUtility,
        icon: Icon(utilityStatus ? Icons.power : Icons.power_off),
      ),
    );
  }
}
