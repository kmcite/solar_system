import 'package:solar_system/domain/apis/panels_repository.dart';
import 'package:solar_system/domain/models/panel.dart';
import 'package:solar_system/main.dart';

mixin PanelsBloc {
  final panels = panelsRepository.call;
  double get panelsPowerCapacity => panelsRepository.powerCapacity;
  final remove = panelsRepository.remove;
}

class PanelsTile extends GUI with PanelsBloc {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'SOLAR PANELS',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Total Power Capacity: $panelsPowerCapacity W'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ...panels().map(
                (panel) {
                  return GestureDetector(
                    onTap: () {
                      remove(panel.id);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.grid_view,
                          size: 40,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${panel.powerCapacity} W',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          panelsRepository.put(
            Panel(),
          );
        },
        icon: const Icon(Icons.add_circle,
            size: 40, color: Colors.green),
        tooltip: 'Add Panel',
      ),
    );
  }
}
