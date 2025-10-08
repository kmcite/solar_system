import 'package:solar_system/domain/settings_repository.dart';
import 'package:solar_system/features/dashboard/inverter/flow_bar.dart';
import 'package:solar_system/features/dashboard/inverter/inverter_mode_toggle.dart';
import 'package:solar_system/features/dashboard/inverter/inverter_voltage_toggle.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/domain/flow_repository.dart';
import 'package:solar_system/domain/inverter_repository.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class InverterState {
  double solarFlow = 0;
  // double maxPower = 0;
  double availablePower = 0;
  double effectivePower = 0;
  double ratedPower = 0;
  // double current = 0;
  InverterMode mode = InverterMode.solar;
  // double voltage = 0;
  double money = 0;
}

class InverterBloc extends Cubit<InverterState> {
  late FlowRepository flow = find();
  late InverterRepository inverterRepository = find();
  late SettingsRepository settingsRepository = find();

  InverterBloc() : super(InverterState());

  @override
  Future<void> initState() async {
    flow.stream.listen(
      (flow) {
        emit(
          state..solarFlow = flow.solarFlow,
        );
        settingsRepository.addMoney(1);
      },
    );
    inverterRepository.stream.listen(
      (inverter) {
        emit(
          state
            ..effectivePower = state.solarFlow > inverter.maxPower
                ? inverter.maxPower
                : state.solarFlow,
        );
      },
    );
    settingsRepository.stream.listen(
      (settings) => emit(state..money = settings.money),
    );
    emit(state..money = settingsRepository().money);
  }

  void onInverterModeToggled() => emit(state..mode = state.mode);
}

class InverterView extends Feature<InverterBloc> {
  @override
  InverterBloc create() => InverterBloc();
  @override
  Widget build(BuildContext context) {
    return FTile(
      title: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Inverter'),
          Row(
            spacing: 8,
            children: [
              InverterModeToggleButton(),
              InverterVoltageToggleButton(),
            ],
          ),
        ],
      ),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowBarView(),
          InverterInformationsView(),
          Text(
            'Available: ${controller().availablePower.toStringAsFixed(0)} W',
          ),
          Text(
            'Effective: ${controller().effectivePower.toStringAsFixed(0)} W',
          ),
          Text('Rated: ${controller().ratedPower.toStringAsFixed(0)} W'),
        ],
      ),
    );
  }
}

class InverterInformationsView extends Feature<_IIB> {
  @override
  _IIB create() => _IIB();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              '${controller().voltage.toStringAsFixed(0)} V',
            ),
            Text('||'),
            Text('${controller().current.toStringAsFixed(2)} A'),
          ],
        ),
        Text(
          'MoneyTalks: ${controller().money.toStringAsFixed(0)} \$',
        ),
        Text(
          'Max Power: ${controller().maxPower.toStringAsFixed(0)} W',
        ),
      ],
    );
  }
}

class _IIB extends Cubit<_IIS> {
  late InverterRepository inverterRepository = find();
  late SettingsRepository settingsRepository = find();
  _IIB() : super(_IIS());
  @override
  Future<void> initState() {
    inverterRepository.stream.listen(
      (inverter) {
        emit(
          state
            ..voltage = inverter.voltage.value
            ..current = inverter.current
            ..maxPower = inverter.maxPower,
        );
      },
    );
    settingsRepository.stream.listen(
      (settings) {
        emit(
          state..money = settings.money,
        );
      },
    );

    return super.initState();
  }
}

class _IIS {
  double voltage = 0;
  double current = 0;
  double money = 0;
  double maxPower = 0;
}
