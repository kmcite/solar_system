import 'package:solar_system/domain/utility_repository.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/utils/bloc/cubit.dart';

class UtilityToggleBloc extends Cubit<bool> {
  late UtilityRepository utilityRepository = find();

  UtilityToggleBloc() : super(false);

  @override
  Future<void> initState() {
    utilityRepository.stream.listen(
      (utility) => emit(utility.status),
    );
    return super.initState();
  }

  void onUtilityToggled() => utilityRepository.toggle();
}

class UtilityToggleButton extends Feature<UtilityToggleBloc> {
  @override
  UtilityToggleBloc create() => UtilityToggleBloc();

  @override
  Widget build(BuildContext context) {
    return FButton.icon(
      onPress: controller.onUtilityToggled,
      child: Icon(
        controller() ? Icons.power : Icons.power_off,
      ),
    );
  }
}
