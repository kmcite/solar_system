import 'package:manager/manager.dart';
import 'package:solar_system/domain/models/panel.dart';

final panelsRepository = PanelsRepository();

class PanelsRepository extends CRUD<Panel> {
  bool contains(int panelId) => crud.contains(panelId);

  double get powerCapacity {
    return call().fold(
      0,
      (value, panel) {
        return value + panel.powerCapacity;
      },
    );
  }
}
