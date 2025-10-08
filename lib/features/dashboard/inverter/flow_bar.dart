import 'package:solar_system/domain/flow_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class FlowBarState {
  double solarFlow = 0;
}

class FlowBarBloc extends Cubit<FlowBarState> {
  late FlowRepository flow = find();

  FlowBarBloc() : super(FlowBarState());

  @override
  Future<void> initState() {
    flow.stream.listen((flow) => emit(state..solarFlow = flow.solarFlow));
    return super.initState();
  }
}

class FlowBarView extends Feature<FlowBarBloc> {
  @override
  FlowBarBloc create() => FlowBarBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Light: ${(controller().solarFlow * 100).toStringAsFixed(0)} %',
        ),
        TweenAnimationBuilder(
          duration: Duration(seconds: 1),
          tween: Tween(begin: 0.0, end: controller().solarFlow),
          builder: (__, value, _) => FDeterminateProgress(value: value),
        ),
      ],
    );
  }
}
