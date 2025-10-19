import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/main.dart';

class InverteVoltageToggleBloc extends Cubit<Voltage> {
  late InverterRepository inverterRepository = find();
  InverteVoltageToggleBloc() : super(Voltage.us);
  void onInverterVolatgeToggled() {
    emit(switch (state) {
      Voltage.eu => Voltage.us,
      Voltage.us => Voltage.eu,
    });
    inverterRepository.setVoltage(state);
  }
}

class InverterVoltageToggleButton extends Feature<InverteVoltageToggleBloc> {
  @override
  Widget build(BuildContext context, controller) {
    return FButton.icon(
      onPress: controller.onInverterVolatgeToggled,
      child: Icon(controller().icon, color: controller().color),
    );
  }

  @override
  InverteVoltageToggleBloc create() => InverteVoltageToggleBloc();
}
