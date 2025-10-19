import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/domain/panels_repository.dart';
import 'package:solar_system/domain/settings_repository.dart';

class SettingsState {
  bool dark = false;
  bool isRestored = true;
}

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState());

  late SettingsRepository settingsRepository = find();
  late PanelsRepository panelsRepository = find();
  late InverterRepository inverterRepository = find();
  @override
  Future<void> initState() async {
    settingsRepository.stream.listen(
      (settings) {
        emit(
          state
            ..dark = settings.dark
            ..isRestored = settings.isRestored,
        );
      },
    );
  }

  void toggleDark() {
    settingsRepository.toggleDark();
  }

  void restoreApp() {
    settingsRepository.restoreApp();
    // panelsRepository.removeAll();
    inverterRepository.sellout();
  }

  void selloutTheInverter() {
    inverterRepository.sellout();
  }

  void buyTheInverter() {
    inverterRepository.buy();
  }
}

class SettingsPage extends Feature<SettingsBloc> {
  const SettingsPage({super.key});
  @override
  SettingsBloc create() => SettingsBloc();

  @override
  Widget build(BuildContext context, controller) {
    return FScaffold(
      header: FHeader(
        title: 'Settings'.text(),
        suffixes: [
          FHeaderAction.x(
            onPress: () => navigator.back(),
            // child: Icon(FIcons.arrowLeft),
          ),
        ],
      ),
      child: Column(
        children: [
          FButton(
            onPress: controller.state.isRestored
                ? null
                : () => controller.restoreApp(),
            child: 'RESTORE APP'.text(),
          ).pad(),
          FButton(
            onPress: controller.state.isRestored
                ? null
                : () => controller.selloutTheInverter(),
            child: 'SELL OUT THE INVERTER'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
