import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/domain/panels_repository.dart';

import '../../main.dart';

class PanelsState {
  bool isSolarMode = false;
  Iterable<Panel> panels = [];
  double get totalPower => panels.fold(0, (a, s) => a + s.power);
  bool loading = false;
  Set<int> panelsToBeRemoved = {};
}

class PanelsBloc extends Cubit<PanelsState> {
  PanelsBloc() : super(PanelsState());

  late InverterRepository inverterRepository = find();
  late PanelsRepository panelsRepository = find();

  @override
  Future<void> initState() {
    emit(state..panels = panelsRepository());
    return super.initState();
  }

  void onPanelAdded() async {
    emit(state..loading = true);
    // await panelsRepository.put(Panel());
    emit(
      state
        ..loading = false
        ..panels = panelsRepository(),
    );
  }

  void onPanelRemoved(Panel panel) async {
    emit(
      state
        ..loading = true
        ..panelsToBeRemoved.add(panel.id),
    );
    // await panelsRepository.remove(panel);
    emit(
      state
        ..loading = false
        ..panels = panelsRepository()
        ..panelsToBeRemoved.remove(panel.id),
    );
  }
}

class PanelsTile extends Feature<PanelsBloc> {
  @override
  PanelsBloc create() => PanelsBloc();

  @override
  Widget build(BuildContext context, controller) {
    return FTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Text(
            'Panels',
            style: TextStyle(
              fontSize: controller().isSolarMode ? 24 : null,
            ),
          ),
          FButton.icon(
            onPress:
                controller().loading ||
                    controller().panelsToBeRemoved.isNotEmpty
                ? null
                : controller.onPanelAdded,
            child:
                controller().loading ||
                    controller().panelsToBeRemoved.isNotEmpty
                ? FCircularProgress.loader()
                : Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final panel in controller().panels)
                FButton.icon(
                  child: controller().panelsToBeRemoved.contains(panel.id)
                      ? FCircularProgress.loader()
                      : Icon(
                          Icons.grid_on,
                          color: Colors.purple,
                        ),
                  onPress: controller().panelsToBeRemoved.contains(panel.id)
                      ? null
                      : () => controller.onPanelRemoved(panel),
                ),
            ],
          ),
          Text(
            '${(controller().totalPower / 1000).toStringAsFixed(3)} kW',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
