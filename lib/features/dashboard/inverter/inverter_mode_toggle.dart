import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class InverteModeToggleBloc extends Cubit<InverterMode> {
  late InverterRepository inverterRepository = find();
  InverteModeToggleBloc() : super(InverterMode.solar);
  void onInverterModeToggled() {
    emit(switch (state) {
      InverterMode.battery => InverterMode.solar,
      InverterMode.solar => InverterMode.utility,
      InverterMode.utility => InverterMode.battery,
    });
    inverterRepository.setMode(state);
  }
}

class InverterModeToggleButton extends Feature<InverteModeToggleBloc> {
  @override
  Widget build(BuildContext context) {
    return FButton.icon(
      onPress: controller.onInverterModeToggled,
      child: Icon(
        controller().icon,
        color: controller().color,
      ),
    );
  }

  @override
  InverteModeToggleBloc create() => InverteModeToggleBloc();
}
