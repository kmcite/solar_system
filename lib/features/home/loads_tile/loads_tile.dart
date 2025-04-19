import 'package:solar_system/domain/apis/loads_repository.dart';
import 'package:solar_system/domain/models/load.dart';
import 'package:solar_system/main.dart';

void _remove(int loadId) => loadsRepository.remove(loadId);
void _put(Load load) => loadsRepository.put(load);

double get _fullPowerUsage => loadsRepository.totalLoad;
Iterable<Load> get _loads => loadsRepository.loads;

class LoadsTile extends GUI {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'LOADS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text('Load: ${_fullPowerUsage} W'),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: _loads.map(
              (load) {
                return ActionChip(
                  label: Text(
                      '${load.name} (${load.power.powerUsage} W)'),
                  onPressed: () => _remove(load.id),
                ).pad(all: 4);
              },
            ).toList(),
          ),
          if (_loads.isEmpty)
            Text(
              'No loads available',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
      trailing: PopupMenuButton(
        // onPressed: () => navigator.toDialog(AddLoadDialog()),
        icon: const Icon(Icons.add_circle,
            size: 28, color: Colors.green),
        tooltip: 'Add Load',
        itemBuilder: (context) => [
          Fan(),
          Iron(),
          Bulb(),
        ].map(
          (any) {
            return PopupMenuItem(
              value: any,
              child: any.name.text(),
            );
          },
        ).toList(),
        onSelected: _put,
      ),
    );
  }
}
