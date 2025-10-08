import 'package:solar_system/main.dart';
import 'package:solar_system/domain/flow_repository.dart';
import 'package:solar_system/utils/bloc/bloc.dart';

class FlowToggleBloc extends Bloc<FlowToggleEvents, Flowing> {
  FlowToggleBloc() : super(Flowing.idle) {
    on<FlowToggleEvents>(
      (event, emit) {
        switch (event) {
          case FlowToggleEvents.stop:
            flowRepository.stopFlow();
            break;
          case FlowToggleEvents.pause:
            flowRepository.pauseFlow();
            break;
          case FlowToggleEvents.resume:
            flowRepository.resumeFlow();
            break;
          case FlowToggleEvents.toggle:
            flowRepository.toggleFlow();
            break;
        }
        emit(flowRepository().flowing);
      },
    );
  }
  late FlowRepository flowRepository = find();
}

class FlowTogglesView extends Feature<FlowToggleBloc> {
  @override
  FlowToggleBloc create() => FlowToggleBloc();
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        FButton.icon(
          // if running, paused then can be stoped
          onPress:
              controller() == Flowing.running || controller() == Flowing.stopped
              ? () => controller(FlowToggleEvents.stop)
              : null,
          child: Icon(
            FIcons.powerOff,
            color: Colors.red,
          ),
        ),
        FButton.icon(
          // if idle, stopped then can be started/resumed
          onPress:
              controller.state == Flowing.idle ||
                  controller() == Flowing.stopped
              ? () => controller(FlowToggleEvents.resume)
              : null,
          child: Icon(
            FIcons.power,
            color: Colors.green,
          ),
        ),
        FButton.icon(
          // if running then can be paused
          onPress: controller.state == Flowing.running
              ? () => controller(FlowToggleEvents.pause)
              : null,
          child: Icon(
            FIcons.pocket,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

enum FlowToggleEvents {
  stop,
  pause,
  resume,
  toggle,
}
