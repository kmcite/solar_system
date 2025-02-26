import 'package:solar_system/navigator.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/system/flow_repository.dart';

class LoadsBloc {
  LoadsBloc() {
    flowRepository.register((_) {
      final effectiveStorageUse = loads.loads;
      flowRepository.useStorage(effectiveStorageUse);
      print('onFlow:LoadsBloc');
    });
  }
  final loadsRM = RM.inject(() => Loads());

  Loads get loads => loadsRM.state;
  set loads(Loads value) =>
      loadsRM
        ..state = value
        ..notify();

  void increaseLoad([int amount = 1]) {
    loads = loads..loads += amount;
  }

  void decreaseLoad([int amount = 1]) {
    loads = loads..loads -= amount;
  }

  bool status([bool? value]) {
    if (value != null) loads = loads..status = value;
    return loads.status;
  }

  void toggle() {
    status(!status());
  }
}

final loadsBloc = LoadsBloc();

class Loads {
  int loads = 100;
  bool status = false;
}

class LoadsPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Loads'.text(),
        actions: [
          FHeaderAction.back(
            onPress: () {
              navigator.back();
            },
          ),
          FButton(
            onPress: loadsBloc.toggle,
            label:
                loadsBloc.status()
                    ? FIcon(FAssets.icons.zapOff)
                    : FIcon(FAssets.icons.zap),
          ),
        ],
      ),
      content: Column(
        children: [
          FButton(
            onPress: () {
              loadsBloc.increaseLoad(50);
            },
            label: 'Add More Loads'.text(),
          ),
          FBadge(
            label: loadsBloc.loads.loads.text(textScaleFactor: 3),
          ).pad(),
          FButton(
            onPress: () {
              loadsBloc.decreaseLoad(150);
            },
            label: 'Decrease Loads'.text(),
          ),
        ],
      ),
    );
  }
}
