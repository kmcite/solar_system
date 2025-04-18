import 'package:solar_system/domain/apis/loads_repository.dart';
import 'package:solar_system/domain/models/load.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/navigator.dart';

mixin LoadsBloc {
  Iterable<Load> get loads => loadsRepository.loads;
  final put = loadsRepository.put;
  final remove = loadsRepository.remove;
  double get fullPowerUsage => loadsRepository.totalLoad;
}

class LoadsTile extends GUI with LoadsBloc {
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
          Text('Load: ${fullPowerUsage} W'),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: loads.map(
              (load) {
                return ActionChip(
                  label: Text('${load.name} (${load.powerUsage}W)'),
                  onPressed: () => remove(load.id),
                ).pad(all: 4);
              },
            ).toList(),
          ),
          if (loads.isEmpty)
            Text(
              'No loads available',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
      trailing: IconButton(
        onPressed: () => navigator.toDialog(AddLoadDialog()),
        icon: const Icon(Icons.add_circle,
            size: 28, color: Colors.green),
        tooltip: 'Add Load',
      ),
    );
  }
}

mixin AddLoadBloc {
  final put = loadsRepository.put;
  final remove = loadsRepository.remove;
  Load load = Load();
  void nameChanged(String value) {
    load.name = value;
  }

  void powerUsageChanged(String value) {
    load.powerUsage = int.tryParse(value) ?? 0;
  }
}

class AddLoadDialog extends GUI with AddLoadBloc {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: load.name,
            onChanged: nameChanged,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Load Name',
              hintText: 'Enter load name',
            ),
          ).pad(),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Power Usage',
              hintText: 'Enter power usage in watts',
              suffixText: 'W',
              border: const OutlineInputBorder(),
            ),
            initialValue: load.powerUsage.toString(),
            onChanged: powerUsageChanged,
          ).pad(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  put(
                    load..id = DateTime.now().millisecondsSinceEpoch,
                  );
                  navigator.back();
                },
                child: const Text('Save'),
              ).pad(),
              FilledButton(
                onPressed: navigator.back,
                child: const Text('No'),
              ).pad(),
            ],
          ).pad(),
        ],
      ).pad(),
    );
  }
}
