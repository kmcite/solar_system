import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_system/main.dart';
import 'package:solar_system/navigator.dart';

final inverterBloc = InverterBloc();

class InverterBloc {
  bool get status => inverterRepository.status;
  int get usage => inverterRepository.usage;
  int get capacity => inverterRepository.capacity;

  bool get upgradable => inverterRepository.upgradable;
  void upgrade() {
    inverterRepository.upgradeCapacity(100);
  }

  void toggleInverter() {
    inverterRepository.toggle();
  }
}

class InverterPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.back(
            onPress: navigator.back,
          ),
        ],
        suffixActions: [
          FHeaderAction(
            onPress: () {
              inverterBloc.toggleInverter();
            },
            icon: inverterBloc.status
                ? FAssets.icons.toggleLeft()
                : FAssets.icons.toggleRight(),
          )
        ],
        title: Text('Inverter Status'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FaIcon(
            FontAwesomeIcons.plugCircleBolt,
            size: 150,
          ).pad(),
          "capacity: ${inverterBloc.capacity} watts"
              .text(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              .pad(),
          "usage: ${inverterBloc.usage} Units"
              .text(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              .pad(),
          Row(
            children: [
              FButton.icon(
                onPress: () {
                  inverterBloc.toggleInverter();
                },
                child: inverterBloc.status
                    ? FAssets.icons.toggleLeft(width: 60)
                    : FAssets.icons.toggleRight(height: 60),
              ).pad(),
              FButton.icon(
                onPress: inverterBloc.upgradable
                    ? () => inverterBloc.upgrade()
                    : null,
                child: FAssets.icons.userPlus(
                  width: 60,
                ),
              ).pad(),
            ],
          ),
        ],
      ),
    );
  }
}
