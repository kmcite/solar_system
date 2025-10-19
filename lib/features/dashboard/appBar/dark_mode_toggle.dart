import 'package:solar_system/main.dart';
import 'package:solar_system/domain/settings_repository.dart';

class DarkModeToggleBloc extends Cubit<bool> {
  DarkModeToggleBloc() : super(false);
  late SettingsRepository settings = find();
  @override
  Future<void> initState() {
    settings.stream.listen((settings) => emit(settings.dark));
    return super.initState();
  }

  void onDarkToggled() {
    settings.toggleDark();
  }
}

class DarkModeToggle extends Feature<DarkModeToggleBloc> {
  @override
  DarkModeToggleBloc create() => DarkModeToggleBloc();
  @override
  Widget build(BuildContext context, controller) {
    return FHeaderAction(
      icon: Icon(controller() ? FIcons.sun : FIcons.moon),
      onPress: controller.onDarkToggled,
    );
  }
}
